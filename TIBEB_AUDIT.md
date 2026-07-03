# 🔬 Tibeb — Production-Level Engineering Audit (v1 — Superseded)

> ⚠️ **This document has been superseded.**
> A complete, corrected, and expanded audit is in **[TIBEB_COMPREHENSIVE_AUDIT.md](./TIBEB_COMPREHENSIVE_AUDIT.md)**.
> Key corrections vs this document: 18 achievements (not 15), brand color palette fully documented,
> additional gaps documented (sleep timer, Amharic font, highlight tags, hyphenation),
> all false claims removed, gamification accuracy improved.

---

> **Auditor Perspective:** Principal Software Architect, Senior Mobile Engineer, UX Expert, Product Manager, Technical Auditor
> **Date:** 2026-07-03
> **Flutter SDK:** ^3.10.7 | **Dart:** 3.10.7 | **Platform:** Android (primary)
> **Codebase:** 78 Dart files | ~18,000 LOC | 3 services | 2 providers | 7 models | 14 reading widgets
> **Benchmark:** Kindle · Readwise Reader · Obsidian · Audible · Kobo · Moon+ Reader

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Feature Status Matrix](#2-feature-status-matrix)
3. [Gap Analysis](#3-gap-analysis)
4. [Architecture Findings](#4-architecture-findings)
5. [Technical Debt](#5-technical-debt)
6. [Code Quality — Module-by-Module Audit](#6-code-quality--module-by-module-audit)
7. [Performance Findings](#7-performance-findings)
8. [Security Audit](#8-security-audit)
9. [UX Review](#9-ux-review)
10. [Accessibility Audit](#10-accessibility-audit)
11. [Testing Audit](#11-testing-audit)
12. [Missing Features](#12-missing-features)
13. [Production Readiness Checklist](#13-production-readiness-checklist)
14. [Prioritized Implementation Roadmap](#14-prioritized-implementation-roadmap)

---

## 1. Executive Summary

### Overall Health Score: 4.5 / 10

| Dimension | Score | Assessment |
|---|:---:|---|
| **Architecture Maturity** | 3/10 | Monolithic provider + god-class screens |
| **Production Readiness** | 3/10 | No sync, no auth, no encryption, no error boundaries |
| **Feature Completeness** | 5/10 | EPUB/PDF reading, gamification work; knowledge system absent |
| **Code Quality** | 4/10 | Working but with severe coupling, god files, zero tests |
| **Performance** | 5/10 | Acceptable for small libraries; will degrade at scale |
| **Security** | 2/10 | Plain-text SQLite, no secure storage, no auth |
| **UX/Design** | 6/10 | Clean aesthetic, good reading themes; lacks polish in flows |
| **Testing** | 1/10 | Only default counter test exists |
| **CI/CD** | 0/10 | No pipeline, no linting enforcement, no automated builds |

### Major Strengths
- **Gamification System:** XP, streaks, 6 Ge'ez-themed ranks, daily quests with weekend 2× multiplier, **18 achievements** — a genuine differentiator among reading apps.
- **EPUB Rendering:** Full HTML injection with custom CSS into a vertical `PageView.builder`, supporting 4 themes (white/cream/dark/AMOLED), 4 typefaces, adjustable line height.
- **PDF Rendering:** `pdfrx` with `ColorFilter` for theme-aware rendering, full-text search via `PdfTextSearcher`, multi-page navigation.
- **Audio Integration:** Multi-track `ConcatenatingAudioSource`, variable speed, track reordering, auto-save every 10 seconds.
- **Software Import Pipeline:** File picker with multi-file support, MD5 deduplication, EPUB metadata + cover extraction.

### Highest-Priority Issues

| # | Issue | Impact | Effort |
|---|---|---|---|
| 1 | **No Cloud Sync / Backup** | Data loss risk = user churn | 3+ weeks |
| 2 | **God Files** (`reading_screen.dart` 2,515 LOC, `library_provider.dart` 1,538 LOC) | Unmaintainable, blocks all new feature work | 2 weeks |
| 3 | **Zero Test Coverage** | Regression risk on every change | 2 weeks |
| 4 | **No Error Boundaries** | App crashes on malformed EPUBs/corrupt files | 3–5 days |
| 5 | **Plain-text SQLite** | User annotation data readable by any root app | 3–5 days |

---

## 2. Feature Status Matrix

> ✅ Complete | 🟡 Partial | ❌ Missing | ⚠️ Needs Redesign

### A. Format Support

| Feature | Status | Quality | Location | Priority | Notes |
|---|:---:|:---:|---|:---:|---|
| EPUB | ✅ | 7/10 | `book_service.dart`, `epub_chapter_page.dart` | — | CSS injection, chapter nav, full-text search |
| PDF | ✅ | 7/10 | `pdf_view.dart`, `pdfrx` | — | ColorFilter themes, text search, outline nav |
| CBZ/CBR | ❌ | — | — | Medium | No comic parser; `archive` pkg is in deps transitively |
| MOBI/AZW3 | ❌ | — | — | Low | No Kindle format support |
| Markdown viewer | ❌ | — | — | Low | `markdown` pkg in deps but unused for reading |
| HTML articles | ❌ | — | — | Medium | No article capture; `webview_flutter` is in deps |

### B. Reading Experience

| Feature | Status | Quality | Location | Notes |
|---|:---:|:---:|---|---|
| Fast page turns | ✅ | 7/10 | `epub_chapter_page.dart` | `PageView.builder` with preloaded chapters |
| Custom fonts | 🟡 | 5/10 | `ReaderSettings.availableTypefaces` | 4 fonts (Merriweather, Georgia, Lexend, System); **no Ethiopic** |
| Font weight control | ❌ | — | — | No slider exposed |
| Letter/word spacing | ❌ | — | — | Not implemented |
| Margin control | ❌ | — | `epub_chapter_page.dart` | Hardcoded `20px` padding |
| Line-height | ✅ | 8/10 | `ReaderSettings.lineHeight` | Slider 1.0–2.5 |
| Hyphenation | ❌ | — | — | No CSS `hyphens: auto` |
| Vertical scrolling | ✅ | 7/10 | Default EPUB mode | |
| Paginated mode | ❌ | — | — | Only vertical scroll |
| RTL support | ❌ | — | — | Only `en_US` locale |
| Amharic rendering | 🟡 | 3/10 | System font only | No bundled Ethiopic font in `assets/` |

### C. Themes

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Light (White) | ✅ | 8/10 | `#FFFFFF` |
| Dark (Blue) | ✅ | 8/10 | `#1A2744` |
| Sepia (Cream) | ✅ | 8/10 | `#F5F0E1` |
| AMOLED Black | ✅ | 8/10 | `#0A0B0E` |
| Auto sunrise/sunset | ❌ | — | No time-based switching |

### D. Navigation

| Feature | Status | Quality | Location | Notes |
|---|:---:|:---:|---|---|
| Table of contents | ✅ | 7/10 | `navigation_sheet.dart` (61KB!) | Integrated bookmarks/highlights/TOC tabs |
| Full-text search (EPUB) | ✅ | 7/10 | `_handleSearch()` in `reading_screen.dart` | Regex across all chapters |
| Full-text search (PDF) | ✅ | 7/10 | `PdfTextSearcher` integration | |
| Progress bar/slider | ✅ | 7/10 | `reading_footer.dart` | Jump-to-percentage support |
| Jump to page | ✅ | 7/10 | `_jumpToPdfPage()` | PDF only |
| Reading history | ❌ | — | — | No recently-read navigation trail |

### E. Annotation System

| Feature | Status | Quality | Location | Notes |
|---|:---:|:---:|---|---|
| Highlights (5 colors) | ✅ | 7/10 | `Highlight` model, `_addHighlight()` | Red, Yellow, Green, Blue, Purple |
| Notes (rich text) | ✅ | 7/10 | `note_editor.dart` → `flutter_quill` | Full rich-text editor |
| Bookmarks | ✅ | 7/10 | `Bookmark` model | Chapter-level with position restore |
| Underline mode | ❌ | — | — | Only background highlight |
| Tag highlights | ❌ | — | — | No `tags` field in `Highlight` model |
| Export highlights | 🟡 | 4/10 | `_exportToMarkdown()` in `reading_screen.dart` | Per-book only; no cross-book export screen |
| Highlight review screen | ❌ | — | — | No cross-book highlights browser |

### F. Audiobook Integration

| Feature | Status | Quality | Location | Notes |
|---|:---:|:---:|---|---|
| MP3 playback | ✅ | 7/10 | `just_audio`, `_loadAudio()` | Multi-file picker |
| M4B support | 🟡 | 5/10 | Depends on codec | `just_audio` can decode some M4B |
| Variable speed | ✅ | 8/10 | `AudioPlayer.setSpeed()` | |
| Multi-track navigation | ✅ | 8/10 | `ConcatenatingAudioSource`, `_showTrackListSheet()` | Track reorder + remove |
| Position resume | ✅ | 7/10 | Auto-save every 10s | |
| Sleep timer | ❌ | — | — | Not implemented |
| Audio-text sync | ❌ | — | — | No Whispersync mapping |

### G. Knowledge System

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Knowledge Graph | ❌ | — | Zero implementation |
| Second Brain queries | ❌ | — | No cross-book conceptual search |
| Spaced Repetition | ❌ | — | No flashcard system |
| Vocabulary builder | 🟡 | 3/10 | `VocabularyLookup` model — stores word only, no definition |

### H. Sync & Reliability

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Offline-first | ✅ | 6/10 | SQLite local DB |
| Cloud sync | ❌ | — | No sync service |
| Encrypted backup | ❌ | — | Plain-text SQLite |
| Data export | 🟡 | 3/10 | Per-book markdown export only |
| Conflict resolution | ❌ | — | — |

### I. Gamification

| Feature | Status | Quality | Location | Notes |
|---|:---:|:---:|---|---|
| Streaks | ✅ | 7/10 | `_calculateStreak()` | Calculated from sessions |
| Reading goals | ✅ | 7/10 | `updateWeeklyGoals()` | Pages/minutes/XP weekly |
| Achievements (15) | ✅ | 7/10 | `_getAchievementTitle()` | Badges for milestones |
| Daily quests (3) | ✅ | 7/10 | `_generateDailyQuests()` | With 2× weekend multiplier |
| XP system | ✅ | 7/10 | `_calculateStats()` | 10/page + 5/min × multiplier |
| Rank system (6 Ge'ez) | ✅ | 8/10 | `TibebConstants.ranks` | Temari → Tibebawi |

### J. AI Features

| Feature | Status | Priority |
|---|:---:|:---:|
| Passage explainer | ❌ | Phase 4 |
| Chapter summarizer | ❌ | Phase 4 |
| Flashcard generator | ❌ | Phase 4 |
| Smart search | ❌ | Phase 4 |

### K. Ethiopian Advantage

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Bundled Amharic fonts | ❌ | — | Zero Ethiopic fonts in `assets/` |
| Amharic OCR | ❌ | — | No OCR |
| Amharic TTS | ❌ | — | No TTS |
| App localization | ❌ | — | English only; only `en_US` in `supportedLocales` |
| Ge'ez manuscripts | ❌ | — | No special viewer |

### L. Universal Capture

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Receive shared files | ✅ | 6/10 | `receive_sharing_intent` wired in `main_navigation.dart` |
| Web clipper | ❌ | — | No web article capture |
| Email/Tweet/Paper capture | ❌ | — | No capture pipeline |

---

## 3. Gap Analysis

### Critical Gaps (Blocking Launch)

| Gap | Impact | Current State | Required State |
|---|---|---|---|
| **No cloud sync** | Users lose all data on device change/loss | Local SQLite only | Encrypted sync + conflict resolution |
| **No error boundaries** | App crashes on corrupt EPUB/PDF | `try-catch` in service but none in UI | `ErrorWidget.builder` + graceful recovery screens |
| **No encrypted storage** | Annotations readable with root | `sqflite` plain-text | `sqflite_sqlcipher` + `flutter_secure_storage` |
| **No auth** | Cannot support sync or multi-device | None | OAuth2 / anonymous auth → Supabase/Firebase |

### High-Impact Gaps

| Gap | Impact | Effort |
|---|---|---|
| No highlight export/review screen | Core "Readwise" differentiator missing | 3–5 days |
| No sleep timer | Basic audiobook expectation | 1–2 days |
| No Amharic fonts bundled | Ethiopian differentiator unusable | 1 day |
| No highlight tags | Cannot organize knowledge | 3–5 days (DB migration v19) |
| No font weight/margin/spacing controls | Below Kindle UX standard | 1–2 days |
| No hyphenation | Ragged text on justified alignment | 1 day (CSS injection) |

### Architectural Gaps

| Gap | Impact |
|---|---|
| No repository pattern | Services are tightly coupled to SQLite; impossible to swap backend |
| No dependency injection | `DatabaseService()` and `BookService()` use singletons/direct instantiation |
| No router/navigation framework | Direct `Navigator.push()` calls; deep linking impossible |
| No analytics/crash reporting | Zero visibility into production behavior |
| No logging framework | Only `debugPrint()` statements |

---

## 4. Architecture Findings

### Current Architecture

```
┌────────────────────────────────────────────────────┐
│  UI Layer (Screens + Widgets)                       │
│  • reading_screen.dart (2,515 LOC — GOD CLASS)     │
│  • navigation_sheet.dart (1,597 LOC)               │
│  • epub_chapter_page.dart (1,046 LOC)              │
│  • library_screen.dart (565 LOC)                   │
│  • dashboard_screen.dart (358 LOC)                 │
├────────────────────────────────────────────────────┤
│  State Layer (Providers)                            │
│  • library_provider.dart (1,538 LOC — GOD CLASS)   │
│  • reader_settings_provider.dart (133 LOC)         │
├────────────────────────────────────────────────────┤
│  Service Layer (Business Logic)                     │
│  • database_service.dart (473 LOC)                 │
│  • book_service.dart (202 LOC)                     │
│  • notification_service.dart (200 LOC)             │
├────────────────────────────────────────────────────┤
│  Model Layer (Data)                                 │
│  • 7 models (book, bookmark, highlight, quest,     │
│    reader_settings, search_result, vocabulary)      │
├────────────────────────────────────────────────────┤
│  Storage Layer                                      │
│  • SQLite (sqflite) — 6 tables, version 18         │
│  • SharedPreferences (reader settings, goals)       │
└────────────────────────────────────────────────────┘
```

### SOLID Violations

| Principle | Violation | Location | Severity |
|---|---|---|:---:|
| **S** — Single Responsibility | `LibraryNotifier` handles books, XP, streaks, quests, achievements, bookmarks, goals, notifications, dictionary, filtering, sorting | `library_provider.dart` | 🔴 Critical |
| **S** — Single Responsibility | `_ReadingScreenState` handles EPUB parsing, PDF rendering, audio playback, search, bookmarks, highlights, orientation, battery, tutorial, progress tracking | `reading_screen.dart` | 🔴 Critical |
| **O** — Open/Closed | Format support requires modifying `processFile()` switch statement | `book_service.dart:16-24` | 🟡 High |
| **D** — Dependency Inversion | `BookService` directly instantiates `DatabaseService()` | `book_service.dart:14` | 🟡 High |
| **I** — Interface Segregation | `LibraryState` has 40+ fields in one giant state object | `library_provider.dart:35-265` | 🟡 High |

### Scalability Risks

1. **Library at 1,000+ books:** No database indices on `books` table. `getBooks()` loads ALL books into memory. No pagination.
2. **Highlights at 10,000+:** `getHighlightsForBook()` has no limit/offset. Navigation sheet builds entire list.
3. **Reading sessions over 1 year:** `getReadingSessions()` loads ALL sessions. Streak calculation iterates every session.
4. **EPUB parsing:** `_processEpub()` in `book_service.dart` calls `file.readAsBytes()`, loading the entire book into RAM. A 500MB EPUB will crash.
5. **MD5 deduplication:** `_calculateFileHash()` reads entire file bytes into memory (`file.readAsBytes()`), will OOM on large PDFs.

### Recommended Target Architecture

```
┌─────────────────────────────────────────────────┐
│  UI Layer (Feature-first)                        │
│  ├── library/ (screen + widgets)                 │
│  ├── reader/ (screen + widgets)                  │
│  │   ├── epub/ (EPUB-specific view)              │
│  │   ├── pdf/ (PDF-specific view)                │
│  │   └── audio/ (player controls)                │
│  ├── knowledge/ (highlights, flashcards)         │
│  ├── stats/ (gamification)                       │
│  └── settings/                                   │
├─────────────────────────────────────────────────┤
│  Application Layer (Use Cases)                   │
│  ├── ImportBookUseCase                           │
│  ├── TrackReadingProgressUseCase                 │
│  ├── ManageAnnotationsUseCase                    │
│  └── SyncDataUseCase                             │
├─────────────────────────────────────────────────┤
│  Domain Layer (Models + Interfaces)              │
│  ├── entities/ (Book, Highlight, Bookmark...)    │
│  └── repositories/ (abstract interfaces)         │
├─────────────────────────────────────────────────┤
│  Data Layer                                      │
│  ├── repositories/ (implementations)             │
│  ├── datasources/ (SQLite, SharedPrefs, API)     │
│  └── dto/ (data transfer objects)                │
└─────────────────────────────────────────────────┘
```

---

## 5. Technical Debt

### 🔴 Critical Priority

| Debt Item | Location | Impact | Effort |
|---|---|---|---|
| **God class: `_ReadingScreenState`** | `reading_screen.dart` (2,515 LOC, 59 methods) | Every new feature (sleep timer, audio sync, new format) requires modifying this monolith. Merge conflicts guaranteed with >1 developer. | 2 weeks |
| **God class: `LibraryNotifier`** | `library_provider.dart` (1,538 LOC, 54 methods) | XP calculation, streak logic, quest generation, bookmark CRUD, notification scheduling, and filtering are all in one `StateNotifier`. Impossible to test units in isolation. | 1.5 weeks |
| **No repository abstraction** | `database_service.dart`, `book_service.dart` | Direct SQLite coupling prevents swapping to cloud backend. Makes offline-first sync architecture impossible. | 1 week |
| **Zero test coverage** | `test/widget_test.dart` (default counter test) | No regression safety. Every change is a deployment risk. | 2 weeks (initial suite) |

### 🟡 High Priority

| Debt Item | Location | Impact | Effort |
|---|---|---|---|
| **`navigation_sheet.dart` (1,597 LOC)** | `screens/reading/widgets/` | A bottom sheet that renders TOC, bookmarks, highlights, jump-to, and notes editing — all in one widget. | 1 week |
| **`epub_chapter_page.dart` (1,046 LOC)** | `screens/reading/widgets/` | Contains CSS injection, text selection, highlight rendering, note creation, context menus, and scroll position tracking. | 1 week |
| **Hardcoded strings** | Throughout: achievement titles, quest descriptions, notification messages, rank names | Blocks localization. | 3–5 days |
| **No database indices** | `database_service.dart` | `SELECT *` on growing tables without indices = slow queries | 1 day |
| **`BookService` reads entire files into memory** | `book_service.dart:192-200` (MD5), `book_service.dart:96` (EPUB) | OOM crash on large files | 2–3 days (streaming hash) |

### 🟢 Medium Priority

| Debt Item | Location | Impact | Effort |
|---|---|---|---|
| No `equals`/`hashCode` on models | All 7 model classes | State comparison fails silently | 1 day |
| `Bookmark` model lacks `copyWith()` | `bookmark_model.dart` | Immutability pattern inconsistency | 30 min |
| `SearchResult.metadata` is `dynamic` | `search_result_model.dart:7` | Type-unsafe, no compile-time checking | 30 min |
| Duplicate `TibebRank` class | `constants.dart:99` vs `tibeb_rank.dart` | Two definitions of the same class | 30 min |
| Commented-out code | `pubspec.yaml:40-43` (old receive_sharing_intent) | Confusing to contributors | 5 min |

---

## 6. Code Quality — Module-by-Module Audit

### 6.1 Models (`lib/models/`) — Score: 6/10

| File | LOC | Quality | Issues |
|---|:---:|:---:|---|
| `book_model.dart` | 217 | 6/10 | Good `copyWith` with sentinel pattern; lacks `equals`/`hashCode`, `toString()` |
| `highlight_model.dart` | 70 | 6/10 | Clean; lacks `tags` field for knowledge system |
| `bookmark_model.dart` | 40 | 5/10 | Missing `copyWith()` method |
| `quest_model.dart` | 80 | 7/10 | Good; uses enum properly |
| `reader_settings_model.dart` | 185 | 7/10 | Well-structured with computed color properties |
| `search_result_model.dart` | 18 | 4/10 | `dynamic metadata` field, no `toMap`/`fromMap` |
| `vocabulary_model.dart` | 46 | 5/10 | Stores word but no definition or context sentence |

**Key Findings:**
- No model uses `freezed`, `equatable`, or manual `operator ==` / `hashCode`. This means Riverpod's `state ==` comparison may miss updates or trigger unnecessary rebuilds.
- Audio track data is stored as JSON-stringified text inside the `books` table. This is a serialization anti-pattern — should be a separate `audio_tracks` table.

### 6.2 Services (`lib/services/`) — Score: 5/10

| File | LOC | Quality | Issues |
|---|:---:|:---:|---|
| `database_service.dart` | 473 | 5/10 | 18 sequential migrations work but are brittle. No indices, no transactions, no batch operations. Singleton pattern bypasses DI. |
| `book_service.dart` | 202 | 5/10 | Reads entire files into memory for MD5 hash and EPUB parsing. Only supports EPUB/PDF. Direct `DatabaseService()` instantiation. `downloadCover()` has no timeout, no size limit. |
| `notification_service.dart` | 200 | 6/10 | Clean singleton. Good channel separation. Missing: notification tap handler doesn't route. |

**Critical Database Issues:**
- No indices on any column. At 1,000+ books, queries degrade.
- `getBooks()` loads ALL books with `SELECT *`. No pagination.
- `getReadingSessions()` loads ALL sessions for streak calculation.
- No `FOREIGN KEY` constraints declared. Data integrity depends entirely on app logic.
- No `ON DELETE CASCADE`. Deleting a book doesn't remove its highlights/bookmarks through SQL — requires manual calls.

### 6.3 Providers (`lib/providers/`) — Score: 3/10

| File | LOC | Quality | Issues |
|---|:---:|:---:|---|
| `library_provider.dart` | 1,538 | 3/10 | **God class.** `LibraryNotifier` handles: book CRUD, XP calc, streak calc, quest generation + update, achievement unlocking, bookmark CRUD, dictionary lookups, filtering/sorting, goal management, notification scheduling. `LibraryState` has 40+ fields. |
| `reader_settings_provider.dart` | 133 | 7/10 | Clean, focused. Uses `SharedPreferences` correctly. |

**Refactoring Recommendation for `library_provider.dart`:**

Split into:
1. `LibraryNotifier` — Book CRUD, filtering, sorting, import.
2. `GamificationNotifier` — XP, levels, streaks, achievements, quests.
3. `AnnotationNotifier` — Highlights, bookmarks, notes, vocabulary.
4. `GoalNotifier` — Weekly goals, reading stats.
5. `SyncNotifier` — (Future) Cloud sync state.

### 6.4 Screens (`lib/screens/`) — Score: 4/10

| File | LOC | Quality | Issues |
|---|:---:|:---:|---|
| `reading_screen.dart` | 2,515 | 3/10 | **God class.** Handles EPUB init, PDF rendering, audio playback, search, bookmarks, highlights, orientation lock, battery monitoring, tutorial, progress tracking, markdown export, dictionary lookup, navigation sheet, and the entire `build()` method (270 LOC). |
| `library_screen.dart` | 565 | 6/10 | Multi-select, delete, batch tag — functional but large. |
| `dashboard_screen.dart` | 358 | 6/10 | Continue reading cards, quick stats. |
| `main_navigation.dart` | 353 | 6/10 | Bottom nav + sharing intent handling. |
| `settings_screen.dart` | 413 | 6/10 | Notification toggles, donation links. |
| `stats_screen.dart` | 267 | 7/10 | Clean stats display. |
| `edit_book_screen.dart` | 348 | 6/10 | Metadata editing, Google image search. |
| `file_selection_screen.dart` | 126 | 7/10 | Simple file browser. |
| `google_image_search_screen.dart` | 162 | 6/10 | WebView-based cover search. |

### 6.5 Reading Widgets (`lib/screens/reading/widgets/`) — Score: 5/10

| File | LOC | Quality | Issues |
|---|:---:|:---:|---|
| `navigation_sheet.dart` | ~1,597 | 4/10 | Monolithic bottom sheet with TOC, bookmarks, highlights, jump slider |
| `epub_chapter_page.dart` | ~1,046 | 5/10 | CSS injection, text selection, highlight rendering in one widget |
| `share_quote_sheet.dart` | ~620 | 6/10 | Quote sharing with styled preview |
| `reading_bottom_controls.dart` | ~348 | 6/10 | Audio controls, display settings trigger |
| `reading_header.dart` | ~235 | 7/10 | Chapter title, clock, battery |
| `reading_audio_section.dart` | ~212 | 7/10 | Audio player UI |
| `reading_footer.dart` | ~155 | 7/10 | Progress bar |
| `note_editor.dart` | ~302 | 6/10 | Quill-based rich text editor |
| `note_view.dart` | ~138 | 7/10 | Note display |
| `epub_view.dart` | ~107 | 7/10 | EPUB container |
| `pdf_view.dart` | ~264 | 6/10 | PDF page rendering with `pdfrx` |
| `reading_search_overlay.dart` | ~78 | 7/10 | Search bar overlay |
| `play_pause_button.dart` | ~36 | 8/10 | Simple animated button |
| `control_button.dart` | ~26 | 8/10 | Reusable icon button |

### 6.6 Components (`lib/components/`) — Score: 7/10

| File | LOC | Quality | Issues |
|---|:---:|:---:|---|
| `book_card.dart` | ~480 | 6/10 | Large; handles grid/list display + progress + selection |
| `daily_activity_sheet.dart` | ~430 | 6/10 | Detailed stats bottom sheet |
| `display_settings_sheet.dart` | ~400 | 6/10 | Theme/font/size controls |
| `daily_quests_card.dart` | ~190 | 7/10 | Quest display with progress |
| `rank_up_dialog.dart` | ~160 | 7/10 | Celebration popup |
| `book_overlay_menu.dart` | ~170 | 7/10 | Context menu |
| `rank_path_widget.dart` | ~140 | 7/10 | Rank progression visualization |
| `activity_graph.dart` | ~140 | 7/10 | GitHub-style heatmap |
| `glass_container.dart` | ~50 | 8/10 | Clean glassmorphism container |
| `streak_widget.dart` | ~35 | 8/10 | Fire animation |
| `stat_badge.dart` | ~30 | 8/10 | Simple stat display |

### 6.7 Core (`lib/core/`) — Score: 6/10

| File | LOC | Quality | Issues |
|---|:---:|:---:|---|
| `constants.dart` | 112 | 5/10 | Contains a duplicate `TibebRank` class (also exists in `tibeb_rank.dart`). Mixes layout constants with rank data. |
| `tibeb_rank.dart` | ~10 | 7/10 | Model-only file |
| `tibeb_rank_data.dart` | ~20 | 7/10 | Static rank definitions |
| `tibeb_rank_repository.dart` | ~20 | 7/10 | Rank lookup |
| `tibeb_rank_extension.dart` | ~15 | 7/10 | Display helpers |
| `tibeb_rank_strings.dart` | ~25 | 7/10 | Localized strings (Ge'ez) |
| Theme subsystem (13 files) | ~300 | 7/10 | Well-organized tokens/semantics/components |

---

## 7. Performance Findings

| Issue | Location | Severity | Fix |
|---|---|:---:|---|
| **Entire EPUB file loaded into RAM** | `book_service.dart:96` (`file.readAsBytes()`) | 🔴 | Stream-based reading or chunk processing |
| **MD5 hash reads entire file** | `book_service.dart:192-200` | 🔴 | Use `md5.startChunkedConversion()` with file stream |
| **All books loaded at startup** | `database_service.dart:245-252` (`getBooks()`) | 🟡 | Pagination with `LIMIT`/`OFFSET`; lazy loading |
| **All sessions loaded for streak** | `database_service.dart:343-346` | 🟡 | SQL query: `SELECT DISTINCT date FROM reading_sessions ORDER BY date DESC LIMIT 365` |
| **No database indices** | `database_service.dart` | 🟡 | Add indices on `bookId`, `date`, `createdAt` |
| **`_applyFilters` rebuilds entire list** | `library_provider.dart:817-925` | 🟢 | Acceptable for <500 books; optimize for >1,000 |
| **No image caching for covers** | `book_card.dart` | 🟢 | Covers are local files — already fast; but stale references on delete |
| **Navigation sheet renders all highlights** | `navigation_sheet.dart` | 🟢 | Use `ListView.builder` (likely already done) |

### Startup Time Analysis

```
main() → WidgetsBinding.ensureInitialized()
       → NotificationService().init()           // ~50ms
       → SystemChrome.setPreferredOrientations() // ~5ms
       → ProviderScope → MaterialApp
       → LibraryNotifier._init()                // DB open + getBooks() + getSessions() + calculateStats()
```

**Concern:** On first launch after a long period, `_init()` must:
1. Open/migrate SQLite database
2. Load ALL books
3. Load ALL reading sessions
4. Calculate stats (iterates every session)
5. Generate daily quests
6. Load notification settings

This is synchronous initialization. With 1,000+ books and 1 year of sessions, this could take 2–5 seconds, blocking the UI.

**Recommendation:** Load only the top 20 recently-read books eagerly. Lazy-load the rest. Move stats calculation to an isolate.

---

## 8. Security Audit

| Area | Status | Severity | Finding |
|---|:---:|:---:|---|
| **Local database** | 🔴 Insecure | Critical | SQLite is unencrypted. Any app with root access can read highlights, notes, progress. |
| **Cover download** | 🟡 Risky | High | `downloadCover()` in `book_service.dart:153-172` downloads from arbitrary URLs with no TLS verification, no size limit, no timeout. |
| **File access** | 🟢 Acceptable | Low | Uses `FilePicker` (SAF-based) — good. No legacy `MANAGE_EXTERNAL_STORAGE`. |
| **Secrets management** | 🟡 Missing | Medium | No API keys used yet. But `http` package is imported — prepare for key management. |
| **Authentication** | 🔴 Missing | Critical | No user identity. Required for any cloud feature. |
| **Secure storage** | 🔴 Missing | Critical | No `flutter_secure_storage`. SharedPreferences stores reading settings in plaintext. |
| **Input validation** | 🟡 Partial | Medium | `Book.fromMap()` does null-coalescing but no sanitization for SQL injection via raw strings. Since using `sqflite` parameterized queries, this is mitigated at the query layer. |
| **Network security** | 🟡 Missing | Medium | No certificate pinning. No `SecurityContext` configuration. |

### Recommendations

1. Migrate to `sqflite_sqlcipher` for at-rest encryption (~3–5 days).
2. Add `flutter_secure_storage` for any tokens/keys.
3. Add request timeout to `http.get()` calls.
4. Implement file size validation before processing imports.

---

## 9. UX Review

### Compared Against: Kindle · Readwise Reader · Kobo · Moon+ Reader · Audible

| Area | Tibeb | Kindle | Assessment |
|---|---|---|---|
| **Library grid** | 3-column grid with cover + progress | Adaptive grid with sorting | Acceptable but lacks list-view toggle at UX level |
| **Reading themes** | 4 themes, instant switch | 4 themes + custom | On par |
| **Font selection** | 4 fonts | 10+ including accessibility fonts | Below average. No Ethiopic font is a critical gap. |
| **Highlight colors** | 5 colors | 4 colors | Good |
| **Notes editor** | Rich text (Quill) | Plain text | **Exceeds** Kindle |
| **Audio integration** | Inline in reader | Separate Audible | **Innovative** — combined reading + listening UX |
| **Gamification** | XP, ranks, streaks, quests | None (Kobo has some) | **Exceeds** all competitors |
| **Knowledge review** | None | Readwise core feature | **Critical gap** for positioning |
| **Onboarding** | Tutorial coach marks | Contextual tips | Acceptable |
| **Settings UX** | Basic screen | Category-organized | Below average |
| **Share quote** | Styled image with accent bar | Basic text share | **Exceeds** Kindle |

### UX Anti-Patterns Found

1. **No loading states:** When importing a large EPUB (e.g., 500 pages), no progress indicator is shown.
2. **No empty states with guidance:** Library empty state exists but could guide users more actively.
3. **No undo for destructive actions:** Deleting a book has soft-delete but no "Undo" snackbar.
4. **No search from library:** Global search is only available inside the reader, not from the library screen.

---

## 10. Accessibility Audit

| Area | Status | Notes |
|---|:---:|---|
| Screen reader (Semantics) | 🟡 Partial | No `Semantics` widgets added manually. Relies on Material defaults. |
| Dynamic font scaling | 🟡 Partial | Reader has its own font size; rest of UI uses Material default scaling. |
| Color contrast | ✅ Good | Dark themes have good contrast ratios. |
| Touch target sizes | 🟡 Partial | Some icon buttons may be below 48×48dp minimum. |
| Keyboard navigation | ❌ Missing | No `FocusNode` management. |
| RTL layout | ❌ Missing | Only `en_US` locale. No `Directionality` handling. |
| Localization | ❌ Missing | No `.arb` files. All strings hardcoded in English. |

---

## 11. Testing Audit

### Current State

| Category | Count | Coverage |
|---|:---:|:---:|
| Unit tests | 0 | 0% |
| Widget tests | 1 (default) | 0% |
| Integration tests | 0 | 0% |
| E2E tests | 0 | 0% |

### Recommended Testing Strategy

**Phase 1 — Foundation (Week 1):**
- Unit tests for `DatabaseService` CRUD operations
- Unit tests for `_calculateStats()`, `_calculateStreak()`, `_generateDailyQuests()`
- Unit tests for `BookService.processFile()` with mock data

**Phase 2 — State Management (Week 2):**
- `LibraryNotifier` state transition tests
- `ReaderSettingsProvider` persistence tests
- Mock-based tests for quest completion flows

**Phase 3 — Widget Tests (Week 3):**
- `BookCard` rendering with various states
- `DisplaySettingsSheet` interaction
- `NavigationSheet` tab switching

**Phase 4 — Integration (Week 4):**
- Import → Read → Highlight → Export flow
- Audio playback → Save position → Resume flow
- XP accumulation → Level up → Rank celebration flow

---

## 12. Missing Features

### 🔴 Must Have (MVP, before launch)

| Feature | Effort | Impact |
|---|---|---|
| Error boundaries + crash recovery UI | 3–5 days | Prevents app crashes on corrupt files |
| Cloud sync backbone (Supabase/Firebase) | 3+ weeks | User trust and multi-device |
| Encrypted local database (`sqflite_sqlcipher`) | 3–5 days | Data security |
| Highlight cross-book review screen | 3–5 days | Core "Readwise" differentiator |
| Sleep timer | 1–2 days | Basic audiobook expectation |
| Bundled Amharic fonts (Abyssinica SIL) | 1 day | Ethiopian differentiator |
| Font weight + margin + spacing controls | 1–2 days | Kindle parity |

### 🟡 Should Have (Post-MVP, v1.1–v1.5)

| Feature | Effort | Impact |
|---|---|---|
| Spaced repetition flashcards | 1–2 weeks | "Readwise + Anki" differentiator |
| Highlight tags + search | 3–5 days | Knowledge organization |
| App localization (am/om/ti/so) | 1–2 weeks | Ethiopian market |
| CBZ/CBR comic support | 3–5 days | Format coverage |
| Auto sunrise/sunset theme | 1–2 days | UX polish |
| Hyphenation (`hyphens: auto`) | 1 day | Typography quality |
| Cross-book full-text search | 3–5 days | Knowledge discovery |
| MOBI/AZW3 import pipeline | 3–5 days | Kindle compatibility |

### 🟢 Nice to Have (v2.0+)

| Feature | Effort | Impact |
|---|---|---|
| Knowledge Graph (concepts/people/ideas) | 3+ weeks | "Obsidian" differentiator |
| AI passage explainer (Gemini API) | 3–5 days | AI-powered intelligence |
| Amharic TTS | 1–2 weeks | Ethiopian accessibility |
| Amharic OCR (camera scanning) | 1–2 weeks | Book digitization |
| Web article clipper | 1–2 weeks | Universal capture |
| Plugin/extension system | 3+ weeks | Ecosystem |
| Social features (reading circles) | 3+ weeks | Community |
| Public API | 1–2 weeks | Developer ecosystem |

---

## 13. Production Readiness Checklist

| Subsystem | Ready? | Blocker | Action Required |
|---|:---:|---|---|
| Reading engine (EPUB) | 🟡 | Crashes on corrupt files | Add error boundaries |
| Reading engine (PDF) | 🟡 | Same as above | Add error boundaries |
| Audio playback | 🟡 | No sleep timer | Implement timer |
| Storage (SQLite) | ❌ | Unencrypted, no indices | Migrate to sqlcipher, add indices |
| Annotation system | 🟡 | No tags, no cross-book view | Add tags field + review screen |
| Gamification | ✅ | — | Production ready |
| Search | 🟡 | EPUB search is blocking (no isolate) | Move to background isolate |
| Sync | ❌ | Not implemented | Build sync service |
| Offline support | 🟡 | Works but no backup/restore | Add encrypted export/import |
| Authentication | ❌ | Not implemented | Required for sync |
| Performance | 🟡 | OOM risk on large files | Stream-based processing |
| Security | ❌ | Plain-text DB, no key management | Encrypt + secure storage |
| Error handling | ❌ | No global boundaries | `ErrorWidget.builder` + Sentry/Crashlytics |
| Monitoring / Analytics | ❌ | No visibility | Firebase Analytics / Custom |
| Logging | ❌ | `debugPrint()` only | Structured logging with `logger` pkg |
| Testing | ❌ | 0% coverage | Minimum 60% before launch |
| CI/CD | ❌ | No pipeline | GitHub Actions: lint → test → build |
| Accessibility | ❌ | No Semantics, no l10n | Add Semantics + `.arb` files |
| Deep linking | ❌ | No router | Add `go_router` |

---

## 14. Prioritized Implementation Roadmap

### Phase 1 — Critical Fixes (Weeks 1–2)

> **Goal:** Make the app stable and safe to ship.

- [ ] **Refactor god files** — Split `reading_screen.dart` into `ReaderController`, `AudioController`, `SearchService`, `BookmarkManager`. Split `LibraryNotifier` into focused notifiers.
- [ ] **Add error boundaries** — `ErrorWidget.builder` globally + try-catch wrappers on EPUB/PDF parsing with user-facing error screens.
- [ ] **Fix OOM risks** — Use `md5.startChunkedConversion()` for file hashing. Limit EPUB file size before loading.
- [ ] **Add database indices** — `CREATE INDEX idx_bookmarks_bookId ON bookmarks(bookId)` (and similar for highlights, sessions).
- [ ] **Set up CI/CD** — GitHub Actions: `flutter analyze`, `flutter test`, `flutter build apk`.

### Phase 2 — MVP Completion (Weeks 3–6)

> **Goal:** Ship v1.0 with differentiated features.

- [ ] **Bundle Amharic fonts** — Package Abyssinica SIL in `assets/fonts/`, add to typeface selector.
- [ ] **Highlight cross-book review screen** — Browse/search/export all highlights across all books.
- [ ] **Sleep timer** — Timer with auto-pause for audio playback.
- [ ] **Tag highlights** — Add `tags` to `Highlight` model + DB migration v19.
- [ ] **Font weight + margin + spacing controls** — Sliders in `DisplaySettingsSheet`.
- [ ] **Hyphenation** — CSS `hyphens: auto` injection for EPUB renderer.
- [ ] **Encrypted local backup** — JSON export/import of annotations + books with AES encryption.
- [ ] **Encrypt SQLite** — Migrate to `sqflite_sqlcipher`.
- [ ] **Basic test suite** — 40% coverage: DB CRUD, stats calculation, streak logic, quest generation.

### Phase 3 — Competitive Features (Weeks 7–14)

> **Goal:** Differentiate Tibeb from standard readers.

- [ ] **Cloud sync** — Supabase backend with offline-first conflict resolution.
- [ ] **Spaced repetition flashcards** — SM-2 algorithm from highlights.
- [ ] **App localization** — Amharic, Afaan Oromo, Tigrinya, Somali.
- [ ] **CBZ/CBR support** — Zip/image comic reader.
- [ ] **Cross-book search** — "What did I learn about X?" across all notes/highlights.
- [ ] **Auto sunrise/sunset theme** — Time-based reader theme switching.
- [ ] **Router migration** — `go_router` for deep linking and navigation.

### Phase 4 — Long-Term Vision (Weeks 15+)

> **Goal:** Build the "Kindle + Readwise + Obsidian + Audible" platform.

- [ ] **Knowledge Graph** — Concepts, people, ideas linked across books.
- [ ] **AI passage explainer** — Gemini API chapter summaries.
- [ ] **Audio-text sync** — Whispersync-style reading/listening synchronization.
- [ ] **Amharic TTS** — On-device text-to-speech.
- [ ] **Amharic OCR** — Camera-based book scanning.
- [ ] **Universal capture** — Web articles, tweets, research papers.
- [ ] **MOBI/AZW3 import** — Kindle format conversion.
- [ ] **Plugin system** — Third-party extensions.
- [ ] **Social features** — Reading circles, shared highlights.
- [ ] **Public API** — Developer ecosystem.
- [ ] **Ethiopian book marketplace** — Curated content store.

---

> **Final Assessment:** Tibeb has a solid reading foundation and a genuinely unique gamification system. The Ethiopian cultural integration (Ge'ez ranks, cultural naming) is a strategic differentiator. However, the codebase has critical architectural debt (god classes, no tests, no sync) that must be resolved before scaling features or team size. With 4–6 weeks of focused refactoring and stabilization, the app can reach MVP readiness for public launch.
