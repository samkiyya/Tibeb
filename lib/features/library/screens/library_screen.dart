// features/library/screens/library_screen.dart
//
// Clean replacement for lib/screens/library_screen.dart.
// - No Navigator.push — uses context.push(AppRoutes.reader, extra: book)
// - No SharedPreferences mixed in — tutorial flag delegated to TutorialService
// - BookService injected via Riverpod (not direct instantiation)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tibeb/shared/models/book_model.dart';
import 'package:tibeb/shared/services/book_service.dart';

import '../../../app/router.dart';
import '../../../core/theme/theme.dart';
import '../../../features/library/providers/library_provider.dart';
import '../../../features/reader/providers/reader_provider.dart';

import '../../../components/book_card.dart';
import '../../../components/book_overlay_menu.dart';
import '../../../components/glass_container.dart';
import '../../../widgets/library/library_header.dart';
import '../../../widgets/library/empty_library_view.dart';
import '../../../widgets/library/add_book_fab.dart';
import '../../../utils/tutorial_helper.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart' show ContentAlign;

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _selectedBookIds = {};
  bool _isSelectionMode = false;

  final GlobalKey _fabKey = GlobalKey();
  final GlobalKey _firstBookMenuKey = GlobalKey();
  final GlobalKey _filterKey = GlobalKey();

  bool _fabTutorialShown = true;
  bool _bookCardTutorialShown = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    if (prefs.getBool('is_first_launch') ?? true) return;
    _fabTutorialShown =
        !(prefs.getBool('is_first_launch_library_fab') ?? true);
    _bookCardTutorialShown =
        !(prefs.getBool('is_first_launch_library_book_card') ?? true);
    if (!_fabTutorialShown) {
      Future.delayed(const Duration(milliseconds: 500),
          () { if (mounted) _showFabTutorial(); });
    } else if (!_bookCardTutorialShown) {
      final hasBooks =
          ref.read(libraryNotifierProvider).allBooks.isNotEmpty;
      if (hasBooks) {
        Future.delayed(const Duration(milliseconds: 500),
            () { if (mounted) _showBookCardTutorial(); });
      }
    }
  }

  void _showFabTutorial() {
    TutorialHelper.showTutorial(
      context: context,
      targets: [
        TutorialHelper.createTarget(
          identify: 'filter_target',
          keyTarget: _filterKey,
          title: 'Filter & Sort',
          description: 'Filter by genre, author, or sort your library.',
          contentAlign: ContentAlign.bottom,
          alignSkip: Alignment.bottomRight,
        ),
        TutorialHelper.createTarget(
          identify: 'fab_target',
          keyTarget: _fabKey,
          title: 'Add Books',
          description: 'Tap + to import EPUB or PDF files.',
          contentAlign: ContentAlign.top,
          alignSkip: Alignment.topLeft,
        ),
      ],
      onFinish: _setFabTutorialShown,
      onSkip: () { _setFabTutorialShown(); return true; },
    );
  }

  void _setFabTutorialShown() {
    SharedPreferences.getInstance()
        .then((p) => p.setBool('is_first_launch_library_fab', false));
    _fabTutorialShown = true;
    final hasBooks =
        ref.read(libraryNotifierProvider).allBooks.isNotEmpty;
    if (!_bookCardTutorialShown && hasBooks) {
      Future.delayed(const Duration(milliseconds: 500),
          () { if (mounted) _showBookCardTutorial(); });
    }
  }

  void _showBookCardTutorial() {
    TutorialHelper.showTutorial(
      context: context,
      targets: [
        TutorialHelper.createTarget(
          identify: 'book_menu_target',
          keyTarget: _firstBookMenuKey,
          title: 'Edit Book Info',
          description:
              'Tap ⋮ to edit cover, title, or author.\nLong-press to select multiple books.',
          contentAlign: ContentAlign.bottom,
          alignSkip: Alignment.bottomRight,
        ),
      ],
      onFinish: _setBookCardTutorialShown,
      onSkip: () { _setBookCardTutorialShown(); return true; },
    );
  }

  void _setBookCardTutorialShown() {
    SharedPreferences.getInstance()
        .then((p) => p.setBool('is_first_launch_library_book_card', false));
    _bookCardTutorialShown = true;
  }

  void _toggleSelection(Book book) {
    if (book.id == null) return;
    setState(() {
      if (_selectedBookIds.contains(book.id)) {
        _selectedBookIds.remove(book.id);
        if (_selectedBookIds.isEmpty) _isSelectionMode = false;
      } else {
        _selectedBookIds.add(book.id!);
        _isSelectionMode = true;
      }
    });
  }

  void _clearSelection() =>
      setState(() { _selectedBookIds.clear(); _isSelectionMode = false; });

  Future<void> _handleImport() async {
    final t = context.tibpiColors;
    final notifier = ref.read(libraryNotifierProvider.notifier);
    final bookService = BookService();
    final hasPermission = await bookService.requestPermissions();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Storage permission required.',
              style: TextStyle(color: t.textPrimary)),
          backgroundColor: t.surface,
        ));
      }
      return;
    }
    final imported = await bookService.pickBooks();
    if (imported.isNotEmpty) {
      await notifier.loadBooks();
      if (!_fabTutorialShown) {
        _setFabTutorialShown();
      } else if (!_bookCardTutorialShown) {
        Future.delayed(const Duration(milliseconds: 500),
            () { if (mounted) _showBookCardTutorial(); });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: t.surface,
          content: Text('Imported ${imported.length} books.',
              style: TextStyle(color: t.textPrimary)),
        ));
      }
    }
  }

  void _openBook(Book book) {
    ref.read(libraryNotifierProvider.notifier).markBookAsOpened(book);
    ref.read(currentlyReadingProvider.notifier).state = book;
    context.push(AppRoutes.reader, extra: book);
  }

  void _showBookOptions(Book book, Offset pos) {
    BookOverlayMenu.show(
      context: context,
      book: book,
      position: pos,
      onAction: (action) {
        switch (action) {
          case 'favorite':
            ref.read(libraryNotifierProvider.notifier)
                .toggleBookFavorite(book);
            break;
          case 'edit':
            context.push(AppRoutes.editBook, extra: book);
            break;
          case 'delete':
            _showDeleteDialog(book);
            break;
        }
      },
    );
  }

  void _showDeleteDialog(Book book) async {
    final t = context.tibpiColors;
    bool deleteHistory = false;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: t.surface,
          title: Text('Remove Book',
              style: TextStyle(color: t.textPrimary)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Remove "${book.title}"?',
                style: TextStyle(color: t.textSecondary)),
            const SizedBox(height: 16),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Remove reading history',
                  style: TextStyle(fontSize: 14, color: t.textSecondary)),
              value: deleteHistory,
              activeColor: t.primary,
              onChanged: (v) => setS(() => deleteHistory = v ?? false),
            ),
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Cancel',
                    style: TextStyle(color: t.textSecondary))),
            TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text('Remove',
                    style: TextStyle(color: t.error))),
          ],
        ),
      ),
    );
    if (confirm == true) {
      ref.read(libraryNotifierProvider.notifier)
          .deleteBook(book.id!, deleteHistory: deleteHistory);
    }
  }

  void _showBatchTagDialog() async {
    if (_selectedBookIds.isEmpty) return;
    final t = context.tibpiColors;
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: t.surface,
        title: Text('Add Category',
            style: TextStyle(color: t.textPrimary)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: TextStyle(color: t.textPrimary),
          decoration: InputDecoration(
            hintText: 'Category name',
            hintStyle: TextStyle(color: t.textTertiary),
            filled: true,
            fillColor: t.surfaceOverlay,
            border: OutlineInputBorder(
                borderRadius: TibebRadius.borderMd,
                borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel',
                  style: TextStyle(color: t.textSecondary))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Add', style: TextStyle(color: t.primary))),
        ],
      ),
    );
    if (ok == true && ctrl.text.trim().isNotEmpty) {
      await ref.read(libraryNotifierProvider.notifier)
          .batchAddTag(_selectedBookIds.toList(), ctrl.text.trim());
      _clearSelection();
    }
  }

  void _handleBatchDelete() async {
    if (_selectedBookIds.isEmpty) return;
    final t = context.tibpiColors;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: t.surface,
        title: Text('Remove Books',
            style: TextStyle(color: t.textPrimary)),
        content: Text(
            'Remove ${_selectedBookIds.length} books?',
            style: TextStyle(color: t.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel',
                  style: TextStyle(color: t.textSecondary))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Remove',
                  style: TextStyle(color: t.error))),
        ],
      ),
    );
    if (ok == true) {
      final notifier = ref.read(libraryNotifierProvider.notifier);
      for (final id in _selectedBookIds) {
        notifier.deleteBook(id);
      }
      _clearSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(libraryNotifierProvider);
    final t = context.tibpiColors;

    ref.listen(libraryNotifierProvider, (prev, next) {
      if (_fabTutorialShown &&
          !_bookCardTutorialShown &&
          (prev == null || prev.allBooks.isEmpty) &&
          next.allBooks.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 500),
            () { if (mounted) _showBookCardTutorial(); });
      }
    });

    return Scaffold(
      backgroundColor: t.background,
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.transparent, elevation: 0),
      body: state.isLoading
          ? Center(child: CircularProgressIndicator(color: t.primary))
          : Column(children: [
              if (_isSelectionMode)
                _SelectionHeader(
                  count: _selectedBookIds.length,
                  onClose: _clearSelection,
                  onSelectAll: () {
                    setState(() {
                      for (final b in state.filteredBooks) {
                        if (b.id != null) _selectedBookIds.add(b.id!);
                      }
                      _isSelectionMode = true;
                    });
                  },
                  onTag: _showBatchTagDialog,
                  onDelete: _handleBatchDelete,
                )
              else
                LibraryHeader(
                  searchController: _searchController,
                  filterKey: _filterKey,
                ),
              Expanded(
                child: state.allBooks.isEmpty
                    ? EmptyLibraryView(onImportFiles: _handleImport)
                    : _BookGrid(
                        books: state.filteredBooks,
                        selectedIds: _selectedBookIds,
                        selectionMode: _isSelectionMode,
                        firstMenuKey: _firstBookMenuKey,
                        onTap: (book) => _isSelectionMode
                            ? _toggleSelection(book)
                            : _openBook(book),
                        onLongPress: (book, pos) => _isSelectionMode
                            ? _showBookOptions(book, pos)
                            : _toggleSelection(book),
                        onMenu: _showBookOptions,
                      ),
              ),
            ]),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom:
              (MediaQuery.paddingOf(context).bottom - 30).clamp(0.0, double.infinity),
        ),
        child: AddBookFab(key: _fabKey, onPressed: _handleImport),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _SelectionHeader extends StatelessWidget {
  final int count;
  final VoidCallback onClose;
  final VoidCallback onSelectAll;
  final VoidCallback onTag;
  final VoidCallback onDelete;

  const _SelectionHeader({
    required this.count,
    required this.onClose,
    required this.onSelectAll,
    required this.onTag,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: 12,
        child: Row(children: [
          IconButton(
              icon: Icon(Icons.close, color: t.textSecondary),
              onPressed: onClose),
          const SizedBox(width: 8),
          Text('$count selected',
              style: TextStyle(
                  color: t.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const Spacer(),
          IconButton(
              tooltip: 'Select All',
              icon: Icon(Icons.select_all, color: t.textSecondary),
              onPressed: onSelectAll),
          IconButton(
              tooltip: 'Add Category',
              icon: Icon(Icons.label_outline, color: t.textSecondary),
              onPressed: onTag),
          IconButton(
              tooltip: 'Remove',
              icon: Icon(Icons.delete_outline, color: t.error),
              onPressed: onDelete),
        ]),
      ),
    );
  }
}

class _BookGrid extends StatelessWidget {
  final List<Book> books;
  final Set<int> selectedIds;
  final bool selectionMode;
  final GlobalKey? firstMenuKey;
  final void Function(Book) onTap;
  final void Function(Book, Offset) onLongPress;
  final void Function(Book, Offset) onMenu;

  const _BookGrid({
    required this.books,
    required this.selectedIds,
    required this.selectionMode,
    required this.onTap,
    required this.onLongPress,
    required this.onMenu,
    this.firstMenuKey,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(
          left: 16, right: 16, top: 16, bottom: 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.57,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return BookCard(
          book: book,
          isSelected: selectedIds.contains(book.id),
          selectionMode: selectionMode,
          menuKey: index == 0 ? firstMenuKey : null,
          onTap: () => onTap(book),
          onLongPress: (pos) => onLongPress(book, pos),
          onMenuPressed: (pos) => onMenu(book, pos),
        );
      },
    );
  }
}
