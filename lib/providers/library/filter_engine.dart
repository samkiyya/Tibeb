import '../../models/book_model.dart';
import '../library_provider.dart';

/// Applies filtering and sorting logic to a list of books based on the current library state.
List<Book> applyBookFilters(List<Book> books, LibraryState currentState) {
  List<Book> filtered = List.from(books);

  // 1. Search filter
  if (currentState.searchQuery.isNotEmpty) {
    final query = currentState.searchQuery.toLowerCase();
    filtered = filtered
        .where(
          (b) =>
              b.title.toLowerCase().contains(query) ||
              b.author.toLowerCase().contains(query),
        )
        .toList();
  }

  // 2. Author filter
  if (currentState.selectedAuthor != 'All') {
    filtered = filtered
        .where((b) => b.author == currentState.selectedAuthor)
        .toList();
  }

  // 2.1 Genre filter
  if (currentState.selectedGenre != 'All') {
    filtered = filtered
        .where((b) => b.genre == currentState.selectedGenre)
        .toList();
  }

  // 3. Status filter
  if (currentState.statusFilter != BookStatusFilter.all) {
    filtered = filtered.where((b) {
      switch (currentState.statusFilter) {
        case BookStatusFilter.unread:
          return b.progress == 0;
        case BookStatusFilter.reading:
          return b.progress > 0 && b.progress < 0.95;
        case BookStatusFilter.finished:
          return b.progress >= 0.95;
        default:
          return true;
      }
    }).toList();
  }

  // 4. Favorites filter
  if (currentState.onlyFavorites) {
    filtered = filtered.where((b) => b.isFavorite).toList();
  }

  // 5. Folder filter
  if (currentState.selectedFolder != 'All') {
    filtered = filtered
        .where((b) => b.folderPath == currentState.selectedFolder)
        .toList();
  }

  // 6. Series filter
  if (currentState.selectedSeries != 'All') {
    filtered = filtered
        .where((b) => b.series == currentState.selectedSeries)
        .toList();
  }

  // 7. Tags filter
  if (currentState.selectedTag != 'All') {
    filtered = filtered
        .where(
          (b) =>
              b.tags != null &&
              b.tags!
                  .split(',')
                  .map((e) => e.trim())
                  .contains(currentState.selectedTag),
        )
        .toList();
  }

  // 7.5 FileType filter
  if (currentState.selectedFileType != 'All') {
    filtered = filtered.where((b) {
      if (currentState.selectedFileType == 'EPUB') {
        return b.filePath.toLowerCase().endsWith('.epub');
      } else if (currentState.selectedFileType == 'PDF') {
        return b.filePath.toLowerCase().endsWith('.pdf');
      } else if (currentState.selectedFileType == 'AUDIO') {
        return b.filePath.toLowerCase().startsWith('audioonly://');
      } else if (currentState.selectedFileType == 'TXT') {
        return b.filePath.toLowerCase().endsWith('.txt');
      } else if (currentState.selectedFileType == 'MD') {
        return b.filePath.toLowerCase().endsWith('.md');
      }
      return true;
    }).toList();
  }

  // 8. Sorting
  filtered.sort((a, b) {
    int cmp;
    switch (currentState.sortBy) {
      case BookSortBy.title:
        cmp = a.title.toLowerCase().compareTo(b.title.toLowerCase());
        break;
      case BookSortBy.author:
        cmp = a.author.toLowerCase().compareTo(b.author.toLowerCase());
        break;
      case BookSortBy.recent:
        cmp = a.addedAt.compareTo(b.addedAt);
        break;
    }
    return currentState.sortAscending ? cmp : -cmp;
  });

  return filtered;
}
