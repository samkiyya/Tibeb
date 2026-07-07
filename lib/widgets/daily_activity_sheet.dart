import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../core/theme/theme.dart';
import 'glass_container.dart';
import '../models/book_model.dart';
import '../providers/library_provider.dart';
import '../screens/reading_screen.dart';

class DailyActivitySheet extends ConsumerWidget {
  final DateTime date;
  final int totalValue;
  final String goalType;
  final List<Book> allBooks;
  final List<dynamic> sessionHistory; // accepts both ReadingSessionEntity and Map

  const DailyActivitySheet({
    super.key,
    required this.date,
    required this.totalValue,
    required this.goalType,
    required this.allBooks,
    required this.sessionHistory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;
    final dateStr = date.toIso8601String().split('T')[0];

    // Normalise each session to a plain map so we can handle both
    // ReadingSessionEntity (Drift) and legacy Map<String, dynamic> entries.
    List<Map<String, dynamic>> toMap(dynamic s) {
      if (s is Map) {
        return [Map<String, dynamic>.from(s)];
      }
      try {
        return [
          {
            'bookId': (s as dynamic).bookId as int,
            'pagesRead': (s as dynamic).pagesRead as int,
            'durationMinutes': (s as dynamic).durationMinutes as int,
            'date': (s as dynamic).date as String,
          },
        ];
      } catch (_) {
        return [];
      }
    }

    final daySessions = sessionHistory
        .expand(toMap)
        .where((s) => s['date'] == dateStr)
        .toList();

    // Group and aggregate sessions by bookId
    final Map<String, Map<String, dynamic>> aggregatedMap = {};
    for (var s in daySessions) {
      final idRaw = s['bookId'];
      if (idRaw == null) continue;
      final bookIdKey = idRaw.toString();

      if (!aggregatedMap.containsKey(bookIdKey)) {
        aggregatedMap[bookIdKey] = {
          'bookId': idRaw is int ? idRaw : int.tryParse(bookIdKey) ?? 0,
          'pagesRead': 0,
          'durationMinutes': 0,
        };
      }
      aggregatedMap[bookIdKey]!['pagesRead'] =
          (aggregatedMap[bookIdKey]!['pagesRead'] as int) +
          (s['pagesRead'] as int? ?? 0);
      aggregatedMap[bookIdKey]!['durationMinutes'] =
          (aggregatedMap[bookIdKey]!['durationMinutes'] as int) +
          (s['durationMinutes'] as int? ?? 0);
    }

    final mergedSessions = aggregatedMap.values.toList();

    return GlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, MMMM d').format(date),
                    style: TextStyle(
                      color: t.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Daily Achievement',
                    style: TextStyle(
                      color: t.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: t.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: t.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '$totalValue $goalType',
                  style: TextStyle(
                    color: t.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Books Read',
            style: TextStyle(
              color: t.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (mergedSessions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No specific book data for this day',
                  style: TextStyle(color: t.textTertiary),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: mergedSessions.length,
                itemBuilder: (context, index) {
                  final session = mergedSessions[index];
                  final bookId = session['bookId'] as int;

                  // Safe search for the book
                  Book? book;
                  try {
                    book = allBooks.firstWhere((b) => b.id == bookId);
                  } catch (_) {
                    // Book might have been deleted but session history remains
                  }

                  final int val;
                  if (goalType == 'pages') {
                    val = session['pagesRead'] as int? ?? 0;
                  } else if (goalType == 'minutes') {
                    val = session['durationMinutes'] as int? ?? 0;
                  } else {
                    // wP
                    final isEpub =
                        book?.filePath.toLowerCase().endsWith('.epub') ?? false;
                    final p = session['pagesRead'] as int? ?? 0;
                    final m = session['durationMinutes'] as int? ?? 0;
                    val = isEpub ? (p * 40 + m * 5) : (p * 10 + m * 5);
                  }

                  if (book == null) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 48,
                            decoration: BoxDecoration(
                              color: t.borderSubtle,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/icon.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Unknown Book (Removed)',
                              style: TextStyle(
                                color: t.textTertiary,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Text(
                            '+$val',
                            style: TextStyle(
                              color: t.textTertiary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {
                        // Close bottom sheet before navigation
                        Navigator.pop(context);

                        ref.read(currentlyReadingProvider.notifier).state =
                            book;
                        ref
                            .read(libraryProvider.notifier)
                            .markBookAsOpened(book!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReadingScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: book.coverPath.startsWith('assets')
                                    ? Image.asset(
                                        book.coverPath,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Image.asset(
                                                    'assets/icon.png',
                                                    fit: BoxFit.contain,
                                                    color: t.textSecondary,
                                                  ),
                                                ),
                                      )
                                    : Image.file(
                                        File(book.coverPath),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Image.asset(
                                                    'assets/icon.png',
                                                    fit: BoxFit.contain,
                                                    color: t.textSecondary,
                                                  ),
                                                ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: TextStyle(
                                      color: t.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    book.author,
                                    style: TextStyle(
                                      color: t.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '+$val',
                              style: TextStyle(
                                color: t.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Keep it up!',
              style: TextStyle(
                color: t.primary.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
