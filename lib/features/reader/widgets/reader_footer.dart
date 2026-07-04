// features/reader/widgets/reader_footer.dart
//
// Thin adapter over ReadingFooter that reads state from ReadingController
// instead of requiring the caller to wire every notifier manually.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/shared/models/models.dart';

import '../../../widgets/reading/reading_footer.dart';
import '../controllers/reading_controller.dart';
import '../providers/reader_provider.dart';

class ReaderFooter extends ConsumerWidget {
  final Book book;
  final ReaderSettings settings;
  final String currentTime;
  final int batteryLevel;
  final ReadingController controller;

  const ReaderFooter({
    super.key,
    required this.book,
    required this.settings,
    required this.currentTime,
    required this.batteryLevel,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');
    final epubState = ref.watch(epubReaderNotifierProvider);

    return ReadingFooter(
      book: book,
      settings: settings,
      currentTime: currentTime,
      currentChapter: isEpub
          ? (controller.chapters.isNotEmpty &&
                  epubState.currentChapterIndex < controller.chapters.length
              ? controller.chapters[epubState.currentChapterIndex].Title ??
                  'Chapter ${epubState.currentChapterIndex + 1}'
              : '')
          : ref.watch(pdfReaderNotifierProvider).currentChapterTitle,
      batteryLevel: batteryLevel,
      scrollProgressNotifier: controller.scrollProgress,
      totalChapters: controller.chapters.length,
      currentChapterIndex: epubState.currentChapterIndex,
      chapterLengths: controller.chapterLengths,
    );
  }
}
