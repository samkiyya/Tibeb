// features/reader/providers/audio_provider.dart
//
// AudioNotifier — Riverpod 3.x, plain Notifier, no codegen.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;

import 'package:tibeb/shared/models/models.dart';
import 'package:tibeb/features/library/providers/library_provider.dart';
import 'reader_provider.dart' show AudioPlayerState;

class AudioNotifier extends Notifier<AudioPlayerState> {
  AudioNotifier._(); // Private — use audioNotifierProvider.notifier
  // ignore: unused_element
  AudioNotifier() : this._();

  late final AudioPlayer _player;
  Timer? _sleepTimer;
  int _lastSavedMs = -1;
  DateTime _lastSaveTime = DateTime.now();

  @override
  AudioPlayerState build() {
    _player = AudioPlayer();
    _player.positionStream.listen(_onPosition);
    _player.durationStream.listen(_onDuration);
    _player.playerStateStream.listen(_onPlayerState);
    _player.currentIndexStream.listen(_onIndex);
    ref.onDispose(() {
      _player.dispose();
      _sleepTimer?.cancel();
    });
    return const AudioPlayerState();
  }

  void _onPosition(Duration pos) {
    state = state.copyWith(position: pos);
    _maybeSave(pos);
  }

  void _onDuration(Duration? dur) =>
      state = state.copyWith(duration: dur ?? Duration.zero);

  void _onPlayerState(PlayerState ps) =>
      state = state.copyWith(isPlaying: ps.playing);

  void _onIndex(int? index) {
    if (index != null) state = state.copyWith(currentTrackIndex: index);
  }

  // ─── Public API ─────────────────────────────────────────────────────────

  Future<void> loadBook(Book book) async {
    final tracks = _tracksFor(book);
    if (tracks.isEmpty) {
      await _player.stop();
      state = const AudioPlayerState();
      return;
    }
    final currentSeqLen = _player.sequence.length;
    if (state.loadedBookId == book.id.toString() &&
        currentSeqLen == tracks.length) {
      return; // already loaded, nothing to do
    }
    state = state.copyWith(isLoading: true);
    try {
      final sources =
          tracks.map((t) => AudioSource.file(t.path, tag: t.title)).toList();
      await _player.setAudioSources(
        sources,
        initialIndex: book.audioLastIndex ?? 0,
        initialPosition: book.audioLastPosition != null
            ? Duration(milliseconds: book.audioLastPosition!)
            : null,
      );
      state = state.copyWith(
        isLoading: false,
        loadedBookId: book.id.toString(),
        currentTrackIndex: book.audioLastIndex ?? 0,
      );
    } catch (e) {
      debugPrint('AudioNotifier.loadBook: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> unload() async {
    await _player.stop();
    state = const AudioPlayerState();
  }

  void togglePlayPause() {
    if (state.isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void skip(Duration delta) {
    final newPos = _player.position + delta;
    final total = _player.duration ?? Duration.zero;
    if (newPos < Duration.zero) {
      _player.seek(Duration.zero);
    } else if (newPos > total) {
      if (_player.hasNext) {_player.seekToNext();}
      else {_player.seek(total);}
    } else {
      _player.seek(newPos);
    }
  }

  void seekToPosition(Duration pos) => _player.seek(pos);
  void seekToTrack(int index) => _player.seek(Duration.zero, index: index);
  void nextTrack() { if (_player.hasNext) _player.seekToNext(); }
  void prevTrack() { if (_player.hasPrevious) _player.seekToPrevious(); }

  void incrementSpeed() {
    const speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
    final cur = state.playbackSpeed;
    final idx = speeds.indexWhere((s) => (s - cur).abs() < 0.01);
    final next = speeds[(idx + 1) % speeds.length];
    _player.setSpeed(next);
    state = state.copyWith(playbackSpeed: next);
  }

  void setSleepTimer(Duration? duration) {
    _sleepTimer?.cancel();
    if (duration == null) {
      state = state.copyWith(sleepTimerRemaining: null);
      return;
    }
    state = state.copyWith(sleepTimerRemaining: duration);
    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final rem = state.sleepTimerRemaining;
      if (rem == null || rem <= Duration.zero) {
        _sleepTimer?.cancel();
        _player.pause();
        state = state.copyWith(sleepTimerRemaining: null);
        return;
      }
      state = state.copyWith(
          sleepTimerRemaining: rem - const Duration(seconds: 1));
    });
  }

  bool get hasNext => _player.hasNext;
  bool get hasPrevious => _player.hasPrevious;

  void _maybeSave(Duration pos) {
    final ms = pos.inMilliseconds;
    final diff = (ms - _lastSavedMs).abs();
    final elapsed = DateTime.now().difference(_lastSaveTime);
    if (elapsed > const Duration(seconds: 10) || diff > 5000) {
      _performSave(ms);
    }
  }

  void _performSave(int ms) {
    final bookId = state.loadedBookId;
    if (bookId == null) return;
    _lastSaveTime = DateTime.now();
    _lastSavedMs = ms;
    ref.read(libraryNotifierProvider.notifier).updateBookAudio(
      int.tryParse(bookId) ?? 0,
      audioLastPosition: ms,
      audioLastIndex: _player.currentIndex ?? 0,
    );
  }

  void savePositionNow() =>
      _performSave(_player.position.inMilliseconds);

  List<AudioTrack> _tracksFor(Book book) {
    if (book.audioTracks.isNotEmpty) return book.audioTracks;
    if (book.audioPath != null && book.audioPath!.isNotEmpty) {
      return [
        AudioTrack(path: book.audioPath!, title: p.basename(book.audioPath!))
      ];
    }
    return [];
  }
}

final audioNotifierProvider =
    NotifierProvider<AudioNotifier, AudioPlayerState>(AudioNotifier.new);
