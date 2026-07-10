import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/core/theme/theme.dart';

import 'package:tibeb/providers/library_provider.dart';
import 'package:tibeb/l10n/app_localizations.dart';

class LibraryHeader extends ConsumerStatefulWidget {
  final TextEditingController searchController;
  final GlobalKey? filterKey;

  const LibraryHeader({
    super.key,
    required this.searchController,
    this.filterKey,
  });

  @override
  ConsumerState<LibraryHeader> createState() => _LibraryHeaderState();
}

class _LibraryHeaderState extends ConsumerState<LibraryHeader> {
  bool _isExpanded = false;

  String _getFileTypeName(AppLocalizations l10n, String type) {
    switch (type.toUpperCase()) {
      case 'ALL':
        return l10n.all;
      case 'AUDIO':
        return l10n.fileTypeAudio;
      case 'TXT':
        return l10n.fileTypePlainText;
      case 'MD':
        return l10n.fileTypeMarkdown;
      default:
        return type;
    }
  }

  String _getShortPath(String path) {
    if (path == 'All') return 'All';
    final parts = path.split(RegExp(r'[/\\]'));
    if (parts.length <= 2) return path;
    return parts.sublist(parts.length - 2).join('/');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(libraryProvider);
    final notifier = ref.read(libraryProvider.notifier);
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.searchController,
                  style: TextStyle(color: t.textPrimary),
                  decoration: InputDecoration(
                    hintText: l10n.searchTitlesAuthors,
                    hintStyle: TextStyle(
                      color: t.textSecondary.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: t.textSecondary,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      key: widget.filterKey,
                      icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.tune_rounded,
                        color: _isExpanded ? t.primary : t.textSecondary,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _isExpanded = !_isExpanded),
                    ),
                    filled: true,
                    fillColor: t.surface,
                    border: OutlineInputBorder(
                      borderRadius: TibebRadius.borderLg,
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: (value) => notifier.setSearchQuery(value),
                ),
              ),
            ],
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Container(
              height: _isExpanded ? null : 0,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          t: t,
                          label: l10n.all,
                          isSelected:
                              state.selectedGenre == 'All' &&
                              state.selectedAuthor == 'All' &&
                              state.selectedFolder == 'All' &&
                              !state.onlyFavorites,
                          onTap: () => notifier.clearFilters(),
                        ),
                        _FilterChip(
                          t: t,
                          label: l10n.favorites,
                          isSelected: state.onlyFavorites,
                          icon: state.onlyFavorites
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          onTap: () => notifier.toggleFavoriteOnly(),
                        ),

                        _FilterChip(
                          t: t,
                          label: state.selectedAuthor == 'All'
                              ? l10n.author
                              : state.selectedAuthor,
                          isSelected: state.selectedAuthor != 'All',
                          hasDropdown: true,
                          dropdownOptions: <String>[
                            l10n.all,
                            ...state.allBooks.map((b) => b.author).toSet(),
                          ].toList(),
                          onSelected: (val) => notifier.setAuthorFilter(val),
                          onTap: () {},
                        ),
                        _FilterChip(
                          t: t,
                          label: state.selectedFolder == 'All'
                              ? l10n.folder
                              : _getShortPath(state.selectedFolder),
                          isSelected: state.selectedFolder != 'All',
                          hasDropdown: true,
                          dropdownOptions: <String>[
                            l10n.all,
                            ...state.allBooks
                                .map((b) => b.folderPath)
                                .whereType<String>()
                                .toSet(),
                          ].toList(),
                          labelMapper: _getShortPath,
                          onSelected: (val) => notifier.setFolderFilter(val),
                          onTap: () {},
                        ),
                        _FilterChip(
                          t: t,
                          label: state.selectedFileType == 'All'
                              ? l10n.fileType
                              : _getFileTypeName(l10n, state.selectedFileType),
                          isSelected: state.selectedFileType != 'All',
                          hasDropdown: true,
                          dropdownOptions: const [
                            'All',
                            'EPUB',
                            'PDF',
                            'AUDIO',
                            'TXT',
                            'MD',
                          ],
                          labelMapper: (val) => _getFileTypeName(l10n, val),
                          onSelected: (val) => notifier.setFileTypeFilter(val),
                          onTap: () {},
                        ),
                        _FilterChip(
                          t: t,
                          label: state.selectedTag == 'All'
                              ? l10n.category
                              : state.selectedTag!,
                          isSelected: state.selectedTag != 'All',
                          hasDropdown: true,
                          dropdownOptions: <String>[
                            l10n.all,
                            ...state.allBooks
                                .where(
                                  (b) => b.tags != null && b.tags!.isNotEmpty,
                                )
                                .expand(
                                  (b) =>
                                      b.tags!.split(',').map((e) => e.trim()),
                                )
                                .where((e) => e.isNotEmpty)
                                .toSet(),
                          ].toList(),
                          onSelected: (val) => notifier.setTagFilter(val),
                          onTap: () {},
                        ),
                        _FilterChip(
                          t: t,
                          label: _getSortName(
                            l10n,
                            state.sortBy.name.toUpperCase(),
                          ),
                          isSelected: state.sortBy != BookSortBy.recent,
                          icon: Icons.sort_rounded,
                          hasDropdown: true,
                          dropdownOptions: BookSortBy.values
                              .map((v) => v.name.toUpperCase())
                              .toList(),
                          labelMapper: (val) => _getSortName(l10n, val),
                          onSelected: (val) {
                            notifier.setSortBy(
                              BookSortBy.values.firstWhere(
                                (e) => e.name.toUpperCase() == val,
                              ),
                            );
                          },
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Status Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatusTab(
                        t: t,
                        label: l10n.statusReading,
                        isSelected:
                            state.statusFilter == BookStatusFilter.reading,
                        onTap: () =>
                            notifier.setStatusFilter(BookStatusFilter.reading),
                      ),
                      _StatusTab(
                        t: t,
                        label: l10n.statusToRead,
                        isSelected:
                            state.statusFilter == BookStatusFilter.unread,
                        onTap: () =>
                            notifier.setStatusFilter(BookStatusFilter.unread),
                      ),
                      _StatusTab(
                        t: t,
                        label: l10n.statusFinished,
                        isSelected:
                            state.statusFilter == BookStatusFilter.finished,
                        onTap: () =>
                            notifier.setStatusFilter(BookStatusFilter.finished),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSortName(AppLocalizations l10n, String name) {
    switch (name.toUpperCase()) {
      case 'RECENT':
        return l10n.sortRecent;
      case 'TITLE':
        return l10n.sortTitle;
      case 'AUTHOR':
        return l10n.sortAuthor;
      case 'PROGRESS':
        return l10n.sortProgress;
      default:
        return name;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final TibebThemeExtension t;
  final String label;
  final bool isSelected;
  final IconData? icon;
  final bool hasDropdown;
  final List<String>? dropdownOptions;
  final String Function(String)? labelMapper;
  final Function(String)? onSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.t,
    required this.label,
    required this.isSelected,
    this.icon,
    this.hasDropdown = false,
    this.dropdownOptions,
    this.labelMapper,
    this.onSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipContent = Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? t.primary : t.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: isSelected ? t.textOnPrimary : t.textSecondary,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: isSelected ? t.textOnPrimary : t.textSecondary,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (hasDropdown) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: isSelected ? t.textOnPrimary : t.textSecondary,
            ),
          ],
        ],
      ),
    );

    if (hasDropdown && dropdownOptions != null && onSelected != null) {
      return PopupMenuButton<String>(
        onSelected: onSelected,
        offset: const Offset(0, 44),
        color: t.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: TibebRadius.borderLg),
        itemBuilder: (context) => (dropdownOptions ?? []).map((opt) {
          final isItemSelected =
              opt == label ||
              labelMapper?.call(opt) == label ||
              (label == 'Genre' && opt == 'All') ||
              (label == 'Author' && opt == 'All') ||
              (label == 'File Type' && opt == 'All') ||
              (label == 'Category' && opt == 'All') ||
              (label == 'Folder' && opt == 'All');
          return PopupMenuItem<String>(
            value: opt,
            child: Text(
              labelMapper?.call(opt) ?? opt,
              style: TextStyle(
                color: t.textPrimary,
                fontSize: 14,
                fontWeight: isItemSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
        child: chipContent,
      );
    }

    return GestureDetector(onTap: onTap, child: chipContent);
  }
}

class _StatusTab extends StatelessWidget {
  final TibebThemeExtension t;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusTab({
    required this.t,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? t.textPrimary : t.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 24 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: t.primary,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: t.primary.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
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
