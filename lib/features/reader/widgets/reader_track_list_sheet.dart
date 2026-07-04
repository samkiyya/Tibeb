// features/reader/widgets/reader_track_list_sheet.dart
//
// Track list bottom sheet — extracted from reading_screen._showTrackListSheet.

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:tibeb/shared/models/models.dart';
import '../../../core/theme/theme.dart';
import '../providers/audio_provider.dart';
import '../../../providers/library_provider.dart';

class ReaderTrackListSheet extends StatelessWidget {
  final Book book;
  final AudioNotifier audioNotifier;
  final LibraryNotifier libraryNotifier;

  const ReaderTrackListSheet({
    super.key,
    required this.book,
    required this.audioNotifier,
    required this.libraryNotifier,
  });

  List<AudioTrack> get _tracks {
    if (book.audioTracks.isNotEmpty) return book.audioTracks;
    if (book.audioPath != null) {
      return [AudioTrack(path: book.audioPath!, title: p.basename(book.audioPath!))];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final tracks = _tracks;

    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.white24,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text('Audiobook Parts',
                style: TextStyle(color: t.textPrimary,
                    fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Flexible(
            child: ReorderableListView.builder(
              shrinkWrap: true,
              itemCount: tracks.length,
              onReorderItem: (old, newIdx) async {
                final reordered = List<AudioTrack>.from(tracks);
                if (old < newIdx) newIdx--;
                final t = reordered.removeAt(old);
                reordered.insert(newIdx, t);
                await libraryNotifier.updateBook(book.copyWith(
                  audioTracks: reordered,
                  audioPath: reordered.isNotEmpty ? reordered.first.path : null,
                ));
              },
              itemBuilder: (ctx, index) {
                final track = tracks[index];
                return ListTile(
                  key: ValueKey(track.path + index.toString()),
                  leading: Icon(Icons.play_circle_outline_rounded,
                      color: t.textSecondary),
                  title: Text(track.title,
                      style: TextStyle(color: t.textPrimary),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('Part ${index + 1}',
                      style: TextStyle(color: t.textSecondary, fontSize: 12)),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      icon: Icon(Icons.delete_outline_rounded,
                          color: t.textSecondary.withValues(alpha: 0.5), size: 20),
                      onPressed: () async {
                        final newTracks = List<AudioTrack>.from(tracks)
                          ..removeAt(index);
                        await libraryNotifier.updateBook(book.copyWith(
                          audioTracks: newTracks,
                          audioPath: newTracks.isNotEmpty
                              ? newTracks.first.path
                              : null,
                        ));
                      },
                    ),
                    Icon(Icons.drag_handle,
                        color: t.textSecondary.withValues(alpha: 0.3), size: 20),
                  ]),
                  onTap: () {
                    audioNotifier.seekToTrack(index);
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
