import 'package:flutter/material.dart';
import '../../../models/book_model.dart';
import '../../../models/bookmark_model.dart';
import '../../../models/highlight_model.dart';
import '../../../models/vocabulary_model.dart';
import '../../../models/reader_settings_model.dart';
import '../../../core/theme/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../note_editor.dart';
import '../note_view.dart';
import 'annotation_header.dart';
import 'annotation_card.dart';
import 'annotation_sharing.dart';

class AnnotationsTab extends StatefulWidget {
  final Book book;
  final Future<List<Bookmark>> Function() getBookmarks;
  final Future<List<Highlight>> Function() getHighlights;
  final Future<List<VocabularyLookup>> Function() getVocabulary;
  final void Function(Highlight) onHighlightTap;
  final Future<void> Function(int) onDeleteHighlight;
  final Future<void> Function(List<int>) onDeleteHighlights;
  final Future<void> Function(Bookmark) onDeleteBookmark;
  final Future<void> Function(List<Bookmark>) onDeleteBookmarks;
  final void Function(Bookmark) onBookmarkTap;
  final Future<void> Function(Highlight) onUpdateHighlight;
  final Function(String)? onLookup;
  final String Function(DateTime) formatDate;
  final VoidCallback? onExport;
  final ReaderSettings readerSettings;

  const AnnotationsTab({
    super.key,
    required this.book,
    required this.getBookmarks,
    required this.getHighlights,
    required this.getVocabulary,
    required this.onHighlightTap,
    required this.onDeleteHighlight,
    required this.onDeleteHighlights,
    required this.onDeleteBookmark,
    required this.onDeleteBookmarks,
    required this.onBookmarkTap,
    required this.onUpdateHighlight,
    this.onLookup,
    required this.formatDate,
    this.onExport,
    required this.readerSettings,
  });

  @override
  State<AnnotationsTab> createState() => _AnnotationsTabState();
}

class _AnnotationsTabState extends State<AnnotationsTab> {
  bool _isSelectionMode = false;
  final Set<int> _selectedHighlightIds = {};
  final Set<int> _selectedBookmarkIds = {};
  final Set<int> _selectedVocabularyIds = {};
  Future<List<dynamic>>? _annotationsFuture;
  String? _selectedFilterColor;

  @override
  void initState() {
    super.initState();
    _refreshAnnotations();
  }

  void _refreshAnnotations() {
    setState(() {
      _annotationsFuture = Future.wait([
        widget.getBookmarks(),
        widget.getHighlights(),
        widget.getVocabulary(),
      ]);
    });
  }

  void _showNoteDetailSheet(BuildContext context, Highlight h) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: context.tibpiColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: context.tibpiColors.accent.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            l10n.highlight.toUpperCase(),
                            style: TextStyle(
                              color: context.tibpiColors.accent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          icon: Icon(
                            Icons.location_on_rounded,
                            size: 16,
                            color: context.tibpiColors.accent,
                          ),
                          label: Text(
                            l10n.goToPosition.toUpperCase(),
                            style: TextStyle(
                              color: context.tibpiColors.accent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Close detail sheet
                            Navigator.pop(context); // Close navigation sheet
                            widget.onHighlightTap(h);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: context.tibpiColors.accent
                                .withValues(alpha: 0.1),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                            minimumSize: const Size(0, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.edit_note_rounded,
                            color: context.tibpiColors.accent,
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Close detail sheet
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => NoteEditor(
                                initialMarkdown: h.note ?? '',
                                initialColor: h.color,
                                settings: widget.readerSettings,
                                onSave: (newNote) => widget.onUpdateHighlight(
                                  h.copyWith(note: newNote),
                                ),
                                onSaveWithColor: (newNote, newColor) async {
                                  final updatedHighlight = h.copyWith(
                                    note: newNote,
                                    color: newColor,
                                  );
                                  await widget.onUpdateHighlight(
                                    updatedHighlight,
                                  );
                                },
                              ),
                            ).then((_) {
                              _refreshAnnotations();
                            });
                          },
                        ),
                        Text(
                          widget.formatDate(h.createdAt),
                          style: const TextStyle(
                            color: Colors.white24,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Text(
                        h.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          height: 1.6,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Serif',
                        ),
                      ),
                    ),
                    if (h.note != null && h.note!.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Icon(
                            Icons.notes_rounded,
                            color: context.tibpiColors.accent,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            l10n.myNote.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      NoteView(
                        markdown: h.note!,
                        settings: widget.readerSettings,
                        fontSize: 16,
                        textColor: Colors.white70,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _annotationsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookmarks = snapshot.data![0] as List<Bookmark>;
        final highlights = snapshot.data![1] as List<Highlight>;
        final vocabulary = snapshot.data![2] as List<VocabularyLookup>;
        final l10n = AppLocalizations.of(context)!;

        if (bookmarks.isEmpty && highlights.isEmpty && vocabulary.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.note_alt_outlined,
                  size: 64,
                  color: Colors.white10,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.noAnnotationsFound,
                  style: const TextStyle(color: Colors.white54, fontSize: 16),
                ),
                if (widget.onExport != null) ...[
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: widget.onExport,
                    icon: const Icon(Icons.ios_share_rounded, size: 18),
                    label: Text(l10n.exportCurrentBook),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.tibpiColors.accent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        final filteredHighlights = _selectedFilterColor == null
            ? highlights
            : highlights.where((h) => h.color == _selectedFilterColor).toList();

        return Column(
          children: [
            AnnotationHeader(
              count: _selectedFilterColor == null
                  ? bookmarks.length + highlights.length + vocabulary.length
                  : bookmarks.length + filteredHighlights.length,
              isSelectionMode: _isSelectionMode,
              selectedCount:
                  _selectedHighlightIds.length +
                  _selectedBookmarkIds.length +
                  _selectedVocabularyIds.length,
              onToggleSelection: () => setState(() => _isSelectionMode = true),
              onCloseSelection: () => setState(() {
                _isSelectionMode = false;
                _selectedHighlightIds.clear();
                _selectedBookmarkIds.clear();
                _selectedVocabularyIds.clear();
              }),
              onDeleteSelected: () async {
                if (_selectedHighlightIds.isNotEmpty) {
                  await widget.onDeleteHighlights(
                    _selectedHighlightIds.toList(),
                  );
                }
                if (_selectedBookmarkIds.isNotEmpty) {
                  final toDelete = bookmarks
                      .where((b) => _selectedBookmarkIds.contains(b.id))
                      .toList();
                  await widget.onDeleteBookmarks(toDelete);
                }

                _refreshAnnotations();
                setState(() {
                  _isSelectionMode = false;
                  _selectedHighlightIds.clear();
                  _selectedBookmarkIds.clear();
                  _selectedVocabularyIds.clear();
                });
              },
              onExport: widget.onExport,
              onShareSelected: () {
                final selectedHighlights = highlights
                    .where((h) => _selectedHighlightIds.contains(h.id))
                    .toList();
                final selectedBookmarks = bookmarks
                    .where((b) => _selectedBookmarkIds.contains(b.id))
                    .toList();
                final selectedVocabulary = vocabulary
                    .where((v) => _selectedVocabularyIds.contains(v.id))
                    .toList();
                AnnotationSharingHelper.shareSelectedAsMarkdown(
                  context: context,
                  book: widget.book,
                  formatDate: widget.formatDate,
                  bookmarks: selectedBookmarks,
                  highlights: selectedHighlights,
                  allVocabulary: _isSelectionMode
                      ? selectedVocabulary
                      : vocabulary,
                );
              },
              onShareQuote: () {
                final selectedHighlights = highlights
                    .where((h) => _selectedHighlightIds.contains(h.id))
                    .toList();
                AnnotationSharingHelper.shareQuotes(
                  context: context,
                  book: widget.book,
                  highlights: selectedHighlights,
                );
              },
            ),
            if (!_isSelectionMode && highlights.isNotEmpty)
              ColorFilterBar(
                selectedColor: _selectedFilterColor,
                onColorTap: (color) {
                  setState(() {
                    if (_selectedFilterColor == color) {
                      _selectedFilterColor = null;
                    } else {
                      _selectedFilterColor = color;
                    }
                  });
                },
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  if (bookmarks.isNotEmpty && _selectedFilterColor == null) ...[
                    ...bookmarks.map((bookmark) {
                      final isSelected =
                          bookmark.id != null &&
                          _selectedBookmarkIds.contains(bookmark.id!);
                      return AnnotationCard(
                        readerSettings: widget.readerSettings,
                        title: bookmark.title,
                        text:
                            '${(bookmark.progress * 100).toStringAsFixed(1)}%',
                        date: widget.formatDate(bookmark.createdAt),
                        isHighlight: false,
                        isSelectionMode: _isSelectionMode,
                        isSelected: isSelected,
                        onSelectedChanged: (val) {
                          setState(() {
                            if (val == true && bookmark.id != null) {
                              _selectedBookmarkIds.add(bookmark.id!);
                            } else if (bookmark.id != null) {
                              _selectedBookmarkIds.remove(bookmark.id!);
                            }
                          });
                        },
                        onDelete: () async {
                          await widget.onDeleteBookmark(bookmark);
                          _refreshAnnotations();
                        },
                        onTap: () {
                          if (_isSelectionMode) {
                            setState(() {
                              if (bookmark.id != null) {
                                if (isSelected) {
                                  _selectedBookmarkIds.remove(bookmark.id!);
                                } else {
                                  _selectedBookmarkIds.add(bookmark.id!);
                                }
                              }
                            });
                          } else {
                            widget.onBookmarkTap(bookmark);
                          }
                        },
                        onLongPress: () {
                          if (!_isSelectionMode && bookmark.id != null) {
                            setState(() {
                              _isSelectionMode = true;
                              _selectedBookmarkIds.add(bookmark.id!);
                            });
                          }
                        },
                      );
                    }),
                  ],
                  if (filteredHighlights.isNotEmpty) ...[
                    ...filteredHighlights.map((h) {
                      final isSelected = _selectedHighlightIds.contains(h.id);
                      return AnnotationCard(
                        readerSettings: widget.readerSettings,
                        text: h.text,
                        note: h.note,
                        date: widget.formatDate(h.createdAt),
                        isHighlight: true,
                        isSelectionMode: _isSelectionMode,
                        isSelected: isSelected,
                        onSelectedChanged: (val) {
                          setState(() {
                            if (val == true && h.id != null) {
                              _selectedHighlightIds.add(h.id!);
                            } else if (h.id != null) {
                              _selectedHighlightIds.remove(h.id!);
                            }
                          });
                        },
                        onDelete: () async {
                          if (h.id != null) {
                            await widget.onDeleteHighlight(h.id!);
                            _refreshAnnotations();
                          }
                        },
                        onTap: () {
                          if (_isSelectionMode) {
                            setState(() {
                              if (h.id != null) {
                                if (isSelected) {
                                  _selectedHighlightIds.remove(h.id!);
                                } else {
                                  _selectedHighlightIds.add(h.id!);
                                }
                              }
                            });
                          } else {
                            widget.onHighlightTap(h);
                          }
                        },
                        onNoteTap: () {
                          if (!_isSelectionMode) {
                            _showNoteDetailSheet(context, h);
                          }
                        },
                        onLongPress: () {
                          if (!_isSelectionMode && h.id != null) {
                            setState(() {
                              _isSelectionMode = true;
                              _selectedHighlightIds.add(h.id!);
                            });
                          }
                        },
                      );
                    }),
                  ],
                  if (vocabulary.isNotEmpty &&
                      _selectedFilterColor == null) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                      child: Text(
                        l10n.vocabulary.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white24,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: vocabulary.map((v) {
                          final isSelected =
                              v.id != null &&
                              _selectedVocabularyIds.contains(v.id!);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: FilterChip(
                              label: Text(
                                v.word,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.white70,
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected && _isSelectionMode,
                              onSelected: (selected) {
                                if (_isSelectionMode && v.id != null) {
                                  setState(() {
                                    if (selected) {
                                      _selectedVocabularyIds.add(v.id!);
                                    } else {
                                      _selectedVocabularyIds.remove(v.id!);
                                    }
                                  });
                                } else {
                                  widget.onLookup?.call(v.word);
                                }
                              },
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.05,
                              ),
                              selectedColor: context.tibpiColors.accent,
                              checkmarkColor: Colors.black,
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 0,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
