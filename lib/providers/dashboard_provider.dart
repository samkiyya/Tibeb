import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tibeb/models/book_model.dart';
import 'package:tibeb/providers/library_provider.dart';

class DashboardState {
  final bool animated;

  final LibraryState library;

  final List<Book> recentBooks;

  const DashboardState({
    required this.animated,

    required this.library,

    required this.recentBooks,
  });

  DashboardState copyWith({
    bool? animated,

    LibraryState? library,

    List<Book>? recentBooks,
  }) {
    return DashboardState(
      animated: animated ?? this.animated,

      library: library ?? this.library,

      recentBooks: recentBooks ?? this.recentBooks,
    );
  }
}

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    final library = ref.watch(libraryProvider);

    final books = library.allBooks.where((b) => b.lastReadAt != null).toList()
      ..sort((a, b) => b.lastReadAt!.compareTo(a.lastReadAt!));

    return DashboardState(
      animated: false,

      library: library,

      recentBooks: books,
    );
  }

  void completeAnimation() {
    state = state.copyWith(animated: true);
  }
}

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);
