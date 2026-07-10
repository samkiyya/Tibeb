import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/core/theme/theme.dart';
import 'package:tibeb/l10n/app_localizations.dart';
import '../../models/reader_settings_model.dart';
import '../../providers/library_provider.dart';
import '../../screens/reading/audio_controller.dart';

/// Shows the audiobook track-list bottom sheet.
/// Extracted from reading_screen's _showTrackListSheet.
void showTrackListSheet({
  required BuildContext context,
  required ReaderSettings settings,
  required AudioController audio,
  required WidgetRef ref,
}) {
  final l10n = AppLocalizations.of(context)!;
  showModalBottomSheet(
    context: context,
    backgroundColor: settings.backgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final latestBook = ref.watch(currentlyReadingProvider);
        if (latestBook == null) return const SizedBox.shrink();

        final tracks = audio.effectiveTracks(latestBook);

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Text(
                  l10n.audiobookParts,
                  style: TextStyle(
                    color: settings.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: ReorderableListView.builder(
                  shrinkWrap: true,
                  itemCount: tracks.length,
                  onReorderItem: (oldIndex, newIndex) async {
                    await audio.reorderTracks(
                      latestBook,
                      oldIndex,
                      newIndex,
                      ref,
                    );
                  },
                  itemBuilder: (context, index) {
                    final track = tracks[index];
                    return ValueListenableBuilder<int>(
                      key: ValueKey(track.path + index.toString()),
                      valueListenable: audio.indexNotifier,
                      builder: (context, currentIndex, _) {
                        final isCurrent = currentIndex == index;
                        return ListTile(
                          leading: Icon(
                            isCurrent
                                ? Icons.play_circle_fill_rounded
                                : Icons.play_circle_outline_rounded,
                            color: isCurrent
                                ? context.tibpiColors.accent
                                : settings.secondaryTextColor,
                          ),
                          title: Text(
                            track.title,
                            style: TextStyle(
                              color: isCurrent
                                  ? context.tibpiColors.accent
                                  : settings.textColor,
                              fontWeight: isCurrent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            l10n.partN(index + 1),
                            style: TextStyle(
                              color: settings.secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: settings.secondaryTextColor.withValues(
                                    alpha: 0.5,
                                  ),
                                  size: 20,
                                ),
                                onPressed: () async {
                                  await audio.removeTrack(
                                    latestBook,
                                    index,
                                    ref,
                                  );
                                },
                              ),
                              Icon(
                                Icons.drag_handle,
                                color: settings.secondaryTextColor.withValues(
                                  alpha: 0.3,
                                ),
                                size: 20,
                              ),
                            ],
                          ),
                          onTap: () {
                            audio.player.seek(Duration.zero, index: index);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    ),
  );
}
