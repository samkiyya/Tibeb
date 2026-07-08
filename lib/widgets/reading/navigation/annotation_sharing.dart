import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/theme.dart';
import '../../../models/book_model.dart';
import '../../../models/bookmark_model.dart';
import '../../../models/highlight_model.dart';
import '../../../models/vocabulary_model.dart';
import '../share_quote_sheet.dart';

class AnnotationSharingHelper {
  static Future<void> shareSelectedAsMarkdown({
    required BuildContext context,
    required Book book,
    required String Function(DateTime) formatDate,
    required List<Bookmark> bookmarks,
    required List<Highlight> highlights,
    required List<VocabularyLookup> allVocabulary,
  }) async {
    bool includeVocabulary = false;

    if (allVocabulary.isNotEmpty) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          bool includeVocab = true;
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: context.tibpiColors.surface,
                title: const Text(
                  'Export Annotations',
                  style: TextStyle(color: Colors.white),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Ready to export your selections as Markdown.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: const Text(
                        'Include Vocabulary List',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      subtitle: const Text(
                        'Add words you looked up in this book',
                        style: TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                      value: includeVocab,
                      activeColor: context.tibpiColors.accent,
                      checkColor: Colors.black,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) =>
                          setDialogState(() => includeVocab = val ?? true),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, includeVocab),
                    child: Text(
                      'SHARE',
                      style: TextStyle(color: context.tibpiColors.accent),
                    ),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            },
          );
        },
      );
      if (result == null) return;
      includeVocabulary = result;
    }

    final buffer = StringBuffer();
    buffer.writeln('# ${book.title} - Selected Annotations');
    buffer.writeln('*Exported with tibeb — ${DateTime.now().year}*');
    buffer.writeln();
    if (book.author.isNotEmpty) {
      buffer.writeln('**Author:** ${book.author}');
    }
    buffer.writeln('**Shared on:** ${formatDate(DateTime.now())}');
    buffer.writeln();

    if (bookmarks.isNotEmpty) {
      buffer.writeln('## Bookmarks');
      for (final b in bookmarks) {
        buffer.writeln(
          '- ${b.title} (${(b.progress * 100).toStringAsFixed(1)}%) — ${formatDate(b.createdAt)}',
        );
      }
      buffer.writeln();
    }

    if (highlights.isNotEmpty) {
      buffer.writeln('## Highlights & Notes');
      for (final h in highlights) {
        buffer.writeln('> ${h.text}');
        buffer.writeln();
        if (h.note != null && h.note!.isNotEmpty) {
          buffer.writeln('**Note:** ${h.note}');
          buffer.writeln();
        }
        final pos = h.position.contains(':')
            ? 'Chapter ${int.parse(h.position.split(':')[0]) + 1}'
            : 'Page ${h.chapterIndex + 1}';
        buffer.writeln('*Position: $pos — ${formatDate(h.createdAt)}*');
        buffer.writeln('---');
      }
    }

    if (includeVocabulary && allVocabulary.isNotEmpty) {
      buffer.writeln('## Vocabulary List');
      buffer.writeln(allVocabulary.map((v) => v.word).join(', '));
      buffer.writeln();
    }

    buffer.writeln();
    buffer.writeln('*Exported with tibeb*');

    try {
      final directory = await getTemporaryDirectory();
      final fileName =
          'tibeb_selection_${DateTime.now().millisecondsSinceEpoch}.md';
      final file = io.File('${directory.path}/$fileName');
      await file.writeAsString(buffer.toString());

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: '${book.title} - Selections',
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to share: $e')));
      }
    }
  }

  static Future<void> shareQuotes({
    required BuildContext context,
    required Book book,
    required List<Highlight> highlights,
  }) async {
    if (highlights.isEmpty) return;

    final quoteText = highlights.map((h) => h.text).join(' ... ');

    ShareQuoteSheet.show(
      context,
      text: quoteText,
      bookTitle: book.title,
      bookAuthor: book.author,
    );
  }
}
