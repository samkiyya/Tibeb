import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart' show EpubChapter;
import 'package:pdfrx/pdfrx.dart' show PdfOutlineNode;

import '../../../models/book_model.dart';
import '../../../models/bookmark_model.dart';
import '../../../models/highlight_model.dart';
import '../../../models/vocabulary_model.dart';
import '../../../models/reader_settings_model.dart';
import '../../../core/theme/theme.dart';
import '../../../l10n/app_localizations.dart';

// Extracted modules
import 'navigation/navigation.dart';

class NavigationSheet extends StatelessWidget {
  final Book book;
  final List<EpubChapter> chapters;
  final List<EpubChapter> tocChapters;
  final List<PdfOutlineNode> pdfOutline;
  final List<PdfOutlineNode> tocPdfOutline;
  final int currentChapterIndex;
  final PdfOutlineNode? currentPdfNode;
  final Function(int) onChapterTap;
  final Function(PdfOutlineNode) onPdfOutlineTap;
  final Future<List<Bookmark>> Function() getBookmarks;
  final Future<List<Highlight>> Function() getHighlights;
  final Future<List<VocabularyLookup>> Function() getVocabulary;
  final List<Highlight> highlights;
  final Function(Highlight) onHighlightTap;
  final Future<void> Function(int) onDeleteHighlight;
  final Future<void> Function(List<int>) onDeleteHighlights;
  final Future<void> Function(Bookmark) onDeleteBookmark;
  final Future<void> Function(List<Bookmark>) onDeleteBookmarks;
  final void Function(Bookmark) onBookmarkTap;
  final Future<void> Function(Highlight) onUpdateHighlight;
  final Function(String)? onLookup;
  final String Function(DateTime) formatDate;
  final void Function(int)? onJumpToPage;
  final void Function(double)? onJumpToPercent;
  final VoidCallback? onExport;
  final bool focusJump;
  final int totalPages;
  final ReaderSettings readerSettings;

  const NavigationSheet({
    super.key,
    required this.book,
    required this.chapters,
    required this.tocChapters,
    required this.pdfOutline,
    required this.tocPdfOutline,
    required this.currentChapterIndex,
    this.currentPdfNode,
    required this.onChapterTap,
    required this.onPdfOutlineTap,
    required this.getBookmarks,
    required this.getHighlights,
    required this.getVocabulary,
    required this.highlights,
    required this.onHighlightTap,
    required this.onDeleteHighlight,
    required this.onDeleteHighlights,
    required this.onDeleteBookmark,
    required this.onDeleteBookmarks,
    required this.onBookmarkTap,
    required this.onUpdateHighlight,
    this.onLookup,
    required this.formatDate,
    this.onJumpToPage,
    this.onJumpToPercent,
    this.onExport,
    this.focusJump = false,
    this.totalPages = 0,
    required this.readerSettings,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: context.tibpiColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            TabBar(
              indicatorColor: context.tibpiColors.accent,
              labelColor: context.tibpiColors.accent,
              unselectedLabelColor: Colors.white54,
              tabs: [
                Tab(text: AppLocalizations.of(context)!.chapters.toUpperCase()),
                Tab(
                  text: AppLocalizations.of(context)!.annotations.toUpperCase(),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ChaptersTab(
                    book: book,
                    chapters: chapters,
                    tocChapters: tocChapters,
                    pdfOutline: pdfOutline,
                    tocPdfOutline: tocPdfOutline,
                    currentChapterIndex: currentChapterIndex,
                    currentPdfNode: currentPdfNode,
                    onChapterTap: onChapterTap,
                    onPdfOutlineTap: onPdfOutlineTap,
                    onJumpToPage: onJumpToPage,
                    onJumpToPercent: onJumpToPercent,
                    totalPages: totalPages,
                    focusJump: focusJump,
                  ),
                  AnnotationsTab(
                    book: book,
                    getBookmarks: getBookmarks,
                    getHighlights: getHighlights,
                    getVocabulary: getVocabulary,
                    onHighlightTap: onHighlightTap,
                    onDeleteHighlight: onDeleteHighlight,
                    onDeleteHighlights: onDeleteHighlights,
                    onDeleteBookmark: onDeleteBookmark,
                    onDeleteBookmarks: onDeleteBookmarks,
                    onBookmarkTap: onBookmarkTap,
                    onUpdateHighlight: onUpdateHighlight,
                    onLookup: onLookup,
                    formatDate: formatDate,
                    onExport: onExport,
                    readerSettings: readerSettings,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
