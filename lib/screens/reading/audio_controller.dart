import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import '../../models/book_model.dart';
import '../../providers/library_provider.dart';

/// Owns the [AudioPlayer] and all audio-related logic extracted from
/// reading_screen.dart. Call [init] once from the widget's initState and
/// [dispose] from the widget's dispose.
class AudioController {
  final AudioPlayer player = AudioPlayer();

  final ValueNotifier<Duration> positionNotifier = ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> durationNotifier = ValueNotifier(Duration.zero);
  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier(false);
  final ValueNotifier<int> indexNotifier = ValueNotifier(0);

  String? _loadedBookId;
  DateTime _lastSaveTime = DateTime.now();
  int _lastSavedMs = -1;
  bool isLoading = false;

  // Slider state (owned here so the position gate is centralized)
  bool isDraggingSlider = false;
  double sliderDragValue = 0.0;

  // Playback speed
  double playbackSpeed = 1.0;

  /// Called once from initState.
  void init() {
    player.positionStream.listen((pos) {
      if (!isDraggingSlider) {
        positionNotifier.value = pos;
      }
      _maybeSave(pos);
    });
    player.durationStream.listen((dur) {
      durationNotifier.value = dur ?? Duration.zero;
    });
    player.playerStateStream.listen((state) {
      isPlayingNotifier.value = state.playing;
    });
    player.currentIndexStream.listen((index) {
      if (index != null) {
        indexNotifier.value = index;
        if (isPlayingNotifier.value) {
          _doSave(0, index: index);
        }
        onIndexChanged?.call();
      }
    });
  }

  void dispose() {
    player.dispose();
    positionNotifier.dispose();
    durationNotifier.dispose();
    isPlayingNotifier.dispose();
    indexNotifier.dispose();
  }

  bool get isLoaded => _loadedBookId != null;
  String? get loadedBookId => _loadedBookId;

  // ── Playback ──────────────────────────────────────────────────────────────

  void togglePlayPause() {
    if (isPlayingNotifier.value) {
      player.pause();
    } else {
      player.play();
    }
  }

  void skip(Duration duration) {
    final newPos = player.position + duration;
    final total = player.duration ?? Duration.zero;
    if (newPos < Duration.zero) {
      player.seek(Duration.zero);
    } else if (newPos > total) {
      if (player.hasNext) {
        player.seekToNext();
      } else {
        player.seek(total);
      }
    } else {
      player.seek(newPos);
    }
  }

  void setSpeed(double speed) {
    player.setSpeed(speed);
  }

  void incrementPlaybackSpeed() {
    if (playbackSpeed >= 2.0) {
      playbackSpeed = 0.5;
    } else {
      playbackSpeed += 0.25;
    }
    player.setSpeed(playbackSpeed);
  }

  // ── Loading ───────────────────────────────────────────────────────────────

  Future<void> load(
    List<AudioTrack> tracks, {
    int? initialIndex,
    int? initialPositionMs,
    String? bookId,
  }) async {
    if (tracks.isEmpty || bookId == null) {
      await player.stop();
      _loadedBookId = null;
      indexNotifier.value = 0;
      return;
    }
    try {
      _loadedBookId = bookId;
      isLoading = true;
      final sources = tracks
          .map((t) => AudioSource.file(t.path, tag: t.title))
          .toList();
      await player.setAudioSources(
        sources,
        initialIndex: initialIndex,
        initialPosition: initialPositionMs != null
            ? Duration(milliseconds: initialPositionMs)
            : null,
      );
      isLoading = false;
    } catch (e) {
      _loadedBookId = null;
      isLoading = false;
      rethrow;
    }
  }

  // ── Track management ──────────────────────────────────────────────────────

  Future<void> pickAndAdd(
    BuildContext context,
    Book book,
    WidgetRef ref,
  ) async {
    final result = await FilePicker.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );
    if (result == null || result.paths.isEmpty) return;

    final List<AudioTrack> newTracks = List.from(book.audioTracks);
    int duplicatesCount = 0;
    for (final path in result.paths) {
      if (path != null) {
        if (!newTracks.any((t) => t.path == path)) {
          newTracks.add(AudioTrack(path: path, title: p.basename(path)));
        } else {
          duplicatesCount++;
        }
      }
    }

    if (duplicatesCount > 0 && context.mounted) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              duplicatesCount == result.paths.length
                  ? 'All selected files are already in this book.'
                  : 'Skipped $duplicatesCount duplicate files.',
            ),
          ),
        );
    }

    if (newTracks.length == book.audioTracks.length) return;

    await ref
        .read(libraryProvider.notifier)
        .updateBook(
          book.copyWith(
            audioTracks: newTracks,
            audioPath: newTracks.first.path,
          ),
        );
    await load(newTracks, bookId: book.id.toString());
  }

  Future<void> removeTrack(Book book, int index, WidgetRef ref) async {
    final tracks = List<AudioTrack>.from(book.audioTracks);
    if (index >= tracks.length) return;
    tracks.removeAt(index);

    final currentIndex = player.currentIndex;
    if (currentIndex != null && currentIndex == index && tracks.isEmpty) {
      await player.stop();
    }

    final updated = book.copyWith(
      audioTracks: tracks,
      audioPath: tracks.isNotEmpty ? tracks.first.path : null,
    );
    await ref.read(libraryProvider.notifier).updateBook(updated);
    await load(tracks, bookId: book.id.toString());

    if (tracks.isNotEmpty && currentIndex != null) {
      final ni = currentIndex >= tracks.length
          ? tracks.length - 1
          : currentIndex;
      await player.seek(Duration.zero, index: ni);
    }
  }

  Future<void> reorderTracks(
    Book book,
    int oldIndex,
    int newIndex,
    WidgetRef ref,
  ) async {
    // ReorderableListView passes indices where newIndex needs adjustment
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final tracks = List<AudioTrack>.from(book.audioTracks);
    final track = tracks.removeAt(oldIndex);
    tracks.insert(newIndex, track);

    await ref
        .read(libraryProvider.notifier)
        .updateBook(
          book.copyWith(
            audioTracks: tracks,
            audioPath: tracks.isNotEmpty ? tracks.first.path : null,
          ),
        );

    final currentPos = player.position;
    final ci = player.currentIndex;
    int? nextIndex;
    if (ci == oldIndex) {
      nextIndex = newIndex;
    } else if (ci != null) {
      if (oldIndex < ci && newIndex >= ci) {
        nextIndex = ci - 1;
      } else if (oldIndex > ci && newIndex <= ci) {
        nextIndex = ci + 1;
      } else {
        nextIndex = ci;
      }
    }

    await load(
      tracks,
      bookId: book.id.toString(),
      initialIndex: nextIndex,
      initialPositionMs: currentPos.inMilliseconds,
    );
    if (nextIndex != null) {
      await player.seek(currentPos, index: nextIndex);
    }
  }

  // ── Position saving ───────────────────────────────────────────────────────

  void _maybeSave(Duration pos) {
    if (_loadedBookId == null || isLoading) return;
    final now = DateTime.now();
    final ms = pos.inMilliseconds;
    final diff = (ms - _lastSavedMs).abs();
    final elapsed = now.difference(_lastSaveTime);
    if (elapsed > const Duration(seconds: 10) || diff > 5000) {
      _doSave(ms, index: player.currentIndex);
    }
  }

  void _doSave(int ms, {int? index}) {
    _lastSaveTime = DateTime.now();
    _lastSavedMs = ms;
    onSavePosition?.call(ms, index ?? player.currentIndex ?? 0);
  }

  void saveNow() {
    _doSave(player.position.inMilliseconds, index: player.currentIndex);
  }

  /// Set this from reading_screen to persist position via Riverpod.
  void Function(int ms, int index)? onSavePosition;

  /// Called when the audio track index changes (for triggering setState).
  VoidCallback? onIndexChanged;

  // ── Helpers ───────────────────────────────────────────────────────────────

  String formatDuration(Duration duration) {
    String two(int n) => n.toString().padLeft(2, '0');
    final m = two(duration.inMinutes.remainder(60));
    final s = two(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? '${two(duration.inHours)}:$m:$s' : '$m:$s';
  }

  List<AudioTrack> effectiveTracks(Book book) {
    if (book.audioTracks.isEmpty && book.audioPath != null) {
      return [
        AudioTrack(path: book.audioPath!, title: p.basename(book.audioPath!)),
      ];
    }
    return book.audioTracks;
  }
}
