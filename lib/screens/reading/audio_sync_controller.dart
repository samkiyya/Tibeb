import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/book_model.dart';
import '../../providers/library_provider.dart';
import 'audio_controller.dart';

/// Bridges [AudioController] with the currently-reading [Book] from Riverpod.
/// Handles: track sync on book change, position persistence, and final flush.
class AudioSyncController {
  AudioSyncController(this._audio);

  final AudioController _audio;

  // ── Setup ─────────────────────────────────────────────────────────────────

  /// Wire position-save callback. Call once from initState with a ref getter.
  void init({required WidgetRef ref, required BuildContext Function() getContext}) {
    _audio.onSavePosition = (ms, index) {
      final book = ref.read(currentlyReadingProvider);
      if (book != null && book.id.toString() == _audio.loadedBookId) {
        ref.read(libraryProvider.notifier).updateBookAudio(
              book.id!,
              audioLastPosition: ms,
              audioLastIndex: index,
            );
      }
    };
  }

  // ── Sync on build ─────────────────────────────────────────────────────────

  /// Called every build cycle to keep the player in sync with the current book.
  /// [onError] receives the error string for showing a SnackBar.
  void syncForBook(
    Book book, {
    required void Function(String message) onError,
  }) {
    final tracks = _audio.effectiveTracks(book);
    final hasAudio = tracks.isNotEmpty;

    bool tracksChanged = false;
    if (hasAudio && _audio.loadedBookId == book.id.toString()) {
      if (_audio.player.sequence.length != tracks.length) {
        tracksChanged = true;
      }
    }

    if (hasAudio && (_audio.loadedBookId != book.id.toString() || tracksChanged)) {
      _audio
          .load(
            tracks,
            bookId: book.id.toString(),
            initialIndex: book.audioLastIndex ?? 0,
            initialPositionMs: book.audioLastPosition ?? 0,
          )
          .catchError((e) => onError('Error loading audio: $e'));
    } else if (!hasAudio && _audio.loadedBookId != null) {
      _audio.load([], bookId: null);
    }
  }

  // ── Final flush ───────────────────────────────────────────────────────────

  /// Guaranteed final write of the current playback position on screen pop.
  void flushOnExit() {
    if (_audio.isLoaded) {
      _audio.saveNow();
    }
  }
}
