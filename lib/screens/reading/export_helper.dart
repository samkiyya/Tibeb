import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tibeb/core/theme/theme.dart';
import '../../models/book_model.dart';
import '../../models/highlight_model.dart';
import '../../providers/library_provider.dart';

/// Handles exporting annotations (bookmarks, highlights, vocabulary)
/// to Markdown and sharing via the system share sheet.
class ExportHelper {
  ExportHelper._();

  static String formatDate(DateTime date) {
    return '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  static Future<void> exportToMarkdown(
    BuildContext context,
    Book book,
    WidgetRef ref,
    List<Highlight> highlights,
  ) async {
    final bookmarks = await ref
        .read(libraryProvider.notifier)
        .getBookmarks(book.id!);
    final vocabulary = await ref
        .read(libraryProvider.notifier)
        .getVocabularyForBook(book.id!);

    bool includeVocabulary = false;
    if (vocabulary.isNotEmpty) {
      if (!context.mounted) return;
      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          bool includeVocab = true;
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: context.tibpiColors.surface,
                title: Text(
                  'Export Annotations',
                  style: TextStyle(color: context.tibpiColors.textPrimary),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ready to export all annotations as Markdown.',
                      style: TextStyle(
                        color: context.tibpiColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: Text(
                        'Include Vocabulary List',
                        style: TextStyle(
                          color: context.tibpiColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        'Add words you looked up in this book',
                        style: TextStyle(
                          color: context.tibpiColors.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                      value: includeVocab,
                      activeColor: context.tibpiColors.accent,
                      checkColor: context.tibpiColors.surface,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) =>
                          setDialogState(() => includeVocab = val ?? true),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: context.tibpiColors.textSecondary,
                      ),
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
    buffer.writeln('# ${book.title}');
    buffer.writeln('*Exported with tibeb — ${DateTime.now().year}*');
    buffer.writeln();
    if (book.author.isNotEmpty) buffer.writeln('**Author:** ${book.author}');
    buffer.writeln('**Exported on:** ${formatDate(DateTime.now())}');
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

    if (includeVocabulary && vocabulary.isNotEmpty) {
      buffer.writeln('## Vocabulary List');
      for (final v in vocabulary) {
        buffer.writeln('- ${v.word} — ${formatDate(v.timestamp)}');
      }
      buffer.writeln();
    }

    buffer.writeln('---');
    buffer.writeln('*Exported with tibeb*');

    if (bookmarks.isEmpty && highlights.isEmpty) {
      buffer.writeln('*No bookmarks or highlights found.*');
    }

    try {
      final directory = await getTemporaryDirectory();
      final fileName =
          '${book.title.replaceAll(RegExp(r'[^\w\s-]'), '')}_annotations.md';
      final file = io.File(p.join(directory.path, fileName));
      await file.writeAsString(buffer.toString());
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: '${book.title} - Annotations',
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to export: $e')));
      }
    }
  }
}
