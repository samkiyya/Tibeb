// features/library/providers/library_provider.dart
//
// Modern Riverpod Notifier — replaces the legacy StateNotifier god class.
// Responsibilities are split:
//   LibraryNotifier      → book CRUD, import, filter, sort
//   GamificationNotifier → XP, levels, streaks, achievements (stats feature)
//   QuestNotifier        → daily quests (stats feature)
//   AnnotationNotifier   → highlights, bookmarks (reader feature)
//
// This file owns only book-library state.
//
// Re-exports legacy provider as a compatibility shim while screens are
// migrated incrementally.

// ─────────────────────────────────────────────────────────────────────────────
// Re-export the refactored provider from its permanent location.
// The legacy lib/providers/library_provider.dart still exists for files not
// yet migrated. New feature files MUST import from this path.
// ─────────────────────────────────────────────────────────────────────────────

export '../../../providers/library_provider.dart';
