# 🔬 Tibeb — Master Engineering & Product Audit
> **Auditor:** Principal Architect · Senior Mobile Engineer · UX Expert · Product Manager
> **Date:** 2026-07-07 | **Flutter SDK:** ^3.10.7 | **Dart SDK:** ^3.10.7
> **Platform:** Android (primary) | **DB:** Drift (SQLite) v1 | **State:** Riverpod 3
> **Codebase:** ~90 Dart files | ~20,000 LOC | 2 services | 3 providers | 7 models | 14 reading widgets | 6 DAOs
> **Vision:** Kindle + Readwise + Obsidian + Audible, built for Ethiopian & global readers

> ⚠️ **This document supersedes both `TIBEB_AUDIT.md` and `TIBEB_COMPREHENSIVE_AUDIT.md`.**
> Key updates: SQLite → Drift migration complete and documented; revised architecture reflecting new
> `core/database/`, `core/repositories/`, and `widgets/` subdirectory structure; all sqflite/
> sqlite3 references corrected; new widgets discovered and catalogued; accurate feature status.

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Brand & Color System](#2-brand--color-system)
3. [Architecture — Current State](#3-architecture--current-state)
4. [Feature Status Matrix](#4-feature-status-matrix)
5. [Module-by-Module Code Audit](#5-module-by-module-code-audit)
6. [Technical Debt Register](#6-technical-debt-register)
7. [Performance Analysis](#7-performance-analysis)
8. [Security Audit](#8-security-audit)
9. [UX Review](#9-ux-review)
10. [Accessibility Audit](#10-accessibility-audit)
11. [Testing Audit](#11-testing-audit)
12. [Gap Analysis — What Must Be Built](#12-gap-analysis)
13. [Production Readiness Checklist](#13-production-readiness-checklist)
14. [Prioritized Roadmap](#14-prioritized-roadmap)

---

## 1. Executive Summary

### Overall Health Score: 5.0 / 10

| Dimension | Score | Assessment |
|---|:---:|---|
| **Architecture Maturity** | 4/10 | Drift migration done; repository pattern added; god-class files still dominate UI layer |
| **Production Readiness** | 3/10 | No sync, no auth, no encryption, no error boundaries |
| **Feature Completeness (MVP)** | 5/10 | EPUB/PDF/Audio/Gamification work; Knowledge System absent |
| **Code Quality** | 4/10 | Functional but severely coupled; god files remain; zero tests |
| **Performance** | 5/10 | Good for <200 books; OOM risks remain on large files |
| **Security** | 2/10 | Plain-text Drift DB file, no secure storage, no auth |
| **UX/Design** | 6/10 | Clean aesthetic, good reading themes; some flows unpolished |
| **Testing** | 1/10 | Only the default counter widget test exists |
| **CI/CD** | 0/10 | No pipeline, no linting enforcement, no automated builds |

### What Changed Since Previous Audits
- ✅ **Drift migration complete** — `database_service.dart` (sqflite) replaced by `core/database/` (Drift). 6 typed DAOs, `AppDatabase`, `DatabaseRepository` abstract interface + `DatabaseRepositoryImpl`, mappers via extension methods. `database_providers.dart` wires it into Riverpod.
- ✅ **Repository pattern added** — `DatabaseRepository` abstract class in `core/repositories/`. First-class domain/entity separation via `mappers.dart`.
- ✅ **Widget structure refactored** — `book_card/` split into 8 focused files. `widgets/stats/` has 5 dedicated widgets: `AchievementsGrid`, `WeeklyGoalCard`, `LevelInfoCard`, `LevelMetadataSheet`, `GoalSettingsSheet`. `widgets/dashboard/` has 3 focused widgets.
- ✅ **Error/Empty/Loading state infrastructure** — Token-based `ErrorState`, `EmptyState`, `Loading` widget families scaffolded under `widgets/` and exported via the theme system.
- ✅ **FOREIGN KEY + WAL** — Drift schema enables `PRAGMA foreign_keys = ON` and `PRAGMA journal_mode = WAL` on every open.
- ✅ **ON DELETE CASCADE** — Drift tables declare `.references(Books, #id, onDelete: KeyAction.cascade)` — referential integrity is now enforced at the DB layer.
- ✅ **AudioTrack type converter** — `AudioTrackListConverter` provides typed JSON serialization for audio tracks via `TypeConverter<List<AudioTrack>, String>`.
- ⚠️ **`database_service.dart` is gone** — all sqflite / sqlite references are fully removed from the codebase. No Dart file in the project references sqflite.

### Major Strengths
- **Gamification System:** XP with time-of-day multipliers (1.5× early/night, 2× weekend), 6 Ge'ez-themed ranks (Temari → Tibebawi), 18 achievements, 3 daily quests with weekend 2× multiplier, reading streak tracking — a genuine differentiator.
- **EPUB Rendering:** Custom `PageView.builder` per chapter, HTML/CSS injection, 5-color highlight span injection via regex, image resolution from EPUB content map, overscroll chapter flip with haptic feedback, auto-scroll via Ticker.
- **PDF Rendering:** `pdfrx` with `ColorFilter` matrix per theme, `PdfTextSearcher` full-text search with result highlighting, outline navigation, programmatic page jumping.
- **Audiobook Integration:** `just_audio` with `ConcatenatingAudioSource` (multi-track), variable speed, track reordering, 10-second position auto-save, resume from last position.
- **Design System:** Token-based with 50+ themed component categories, feature placeholder tokens for AI/Knowledge Graph/Sync already scaffolded.
- **Drift DB Layer:** Typed schema, DAOs, repository abstraction, FK cascades, WAL journal — a major quality improvement over the old sqflite implementation.

### Highest-Priority Issues (The Blockers)

| # | Issue | Impact | Estimated Effort |
|---|---|---|---|
| 1 | **No cloud sync/backup** | Total data loss on device change | 3+ weeks |
| 2 | **God files** (`reading_screen.dart` 2,515 LOC; `library_provider.dart` 1,538 LOC; `navigation_sheet.dart` ~1,597 LOC) | Unmaintainable; blocks all new feature work | 2 weeks |
| 3 | **Zero test coverage** | Any change is a regression risk | 2 weeks |
| 4 | **No error boundaries** | App crashes on corrupt EPUB/PDF silently | 3–5 days |
| 5 | **Plain-text Drift DB file** | Annotations readable by root apps | 3–5 days |

---

## 2. Brand & Color System

### Brand Palette
| Token | Hex | Usage |
|---|---|---|
| Deep Navy | `#0d1321` | App background (dark mode base) |
| Warm Brown | `#3b2f2f` | Surface containers, cards |
| Bronze | `#6b4e16` | Secondary surfaces, borders |
| Gold | `#d4af37` | **Primary accent** — XP, streaks, highlights |
| Parchment | `#e7d9b5` | Sepia reader background, warm tones |
| Cream | `#f7f3e6` | Light reader background |

### Reader Themes (Currently Implemented)
| Theme ID | Background | Text | Notes |
|---|---|---|---|
| `white` | `#FFFFFF` | `#1A1A1A` | Bright light mode |
| `cream` | `#F5F0E1` | `#333333` | Warm sepia (close to brand `#f7f3e6`) |
| `darkBlue` | `#1A2744` | `#E0E0E0` | Dark blue night mode |
| `black` | `#0A0B0E` | `#FFFFFF` | AMOLED black (close to brand `#0d1321`) |

### Highlight Colors (Reader)
5 colors from `TibebThemeExtension.highlightColors`:
Yellow, Green, Blue, Pink, Orange — mapped to `reader.highlightYellow`, `reader.highlightGreen`, etc.

### Brand Color Gaps
- `#d4af37` (Gold) is the natural XP/accent color but not yet mapped as an explicit named `goldPrimary` design token.
- `#3b2f2f` (Warm Brown) and `#6b4e16` (Bronze) not present as named design tokens in the color system.
- The parchment `#e7d9b5` and cream `#f7f3e6` should align precisely with the reader cream theme `#F5F0E1`.

---

## 3. Architecture — Current State

### Architecture Diagram (As-Built)

```
┌──────────────────────────────────────────────────────────────┐
│  UI Layer                                                      │
│                                                                │
│  screens/ (9 files)                                           │
│    GOD FILE: reading_screen.dart     (~2,515 LOC, 59 methods) │
│    GOD FILE: library_screen.dart     (565 LOC)                │
│    dashboard_screen.dart             (358 LOC)                │
│    stats_screen.dart                 (267 LOC)                │
│    settings_screen.dart              (413 LOC)                │
│    edit_book_screen.dart             (348 LOC)                │
│    main_navigation.dart              (353 LOC)                │
│    google_image_search_screen.dart   (162 LOC)                │
│    file_selection_screen.dart        (126 LOC — ORPHANED)     │
│                                                                │
│  widgets/reading/ (14 files)                                  │
│    GOD FILE: navigation_sheet.dart   (~1,597 LOC)             │
│    GOD FILE: epub_chapter_page.dart  (~1,046 LOC)             │
│    pdf_view, note_editor, audio sections, etc.                │
│                                                                │
│  widgets/book_card/ (8 files — refactored)                    │
│  widgets/stats/ (5 files — refactored)                        │
│  widgets/dashboard/ (3 files — refactored)                    │
│  widgets/empty_state/ widgets/error_state/ widgets/loading/   │
│    (token infrastructure — not yet used in UI)                │
│                                                                │
├──────────────────────────────────────────────────────────────┤
│  State Layer (Riverpod)                                        │
│    GOD FILE: library_provider.dart   (1,538 LOC, 54 methods) │
│    reader_settings_provider.dart     (133 LOC — clean)        │
│    database_providers.dart           (17 LOC — clean)         │
│    currentlyReadingProvider          (StateProvider<Book?>)   │
│    themeModeProvider                 (NotifierProvider)        │
│                                                                │
├──────────────────────────────────────────────────────────────┤
│  Repository Layer  ✅ NEW                                      │
│    core/repositories/                                         │
│      DatabaseRepository (abstract interface)                  │
│      DatabaseRepositoryImpl (Drift implementation)            │
│      mappers.dart (extension methods: entity ↔ domain)        │
│                                                                │
├──────────────────────────────────────────────────────────────┤
│  Database Layer (Drift)  ✅ MIGRATED FROM SQFLITE             │
│    core/database/                                             │
│      AppDatabase (schemaVersion: 1)                           │
│      tables.dart (6 typed tables with FK constraints)         │
│      audio_track_converter.dart (TypeConverter)               │
│      database.g.dart (generated)                              │
│      daos/                                                     │
│        BooksDao + books_dao.g.dart                            │
│        HighlightsDao + highlights_dao.g.dart                  │
│        BookmarksDao + bookmarks_dao.g.dart                    │
│        QuestsDao + quests_dao.g.dart                          │
│        ReadingSessionsDao + reading_sessions_dao.g.dart       │
│        DictionaryLookupsDao + dictionary_lookups_dao.g.dart   │
│                                                                │
├──────────────────────────────────────────────────────────────┤
│  Service Layer                                                 │
│    book_service.dart     (202 LOC) — file import, EPUB/PDF   │
│    notification_service.dart (200 LOC) — local notifications  │
│    ⚠️ database_service.dart REMOVED (was sqflite, now Drift)  │
│                                                                │
├──────────────────────────────────────────────────────────────┤
│  Model Layer (7 domain models)                                 │
│    book, bookmark, highlight, quest,                          │
│    reader_settings, search_result, vocabulary                  │
│                                                                │
├──────────────────────────────────────────────────────────────┤
│  Core                                                          │
│    rank/ (5 files) — 6 Ge'ez rank tiers + repository         │
│    theme/ (~80+ files) — Token-based design system            │
│                                                                │
├──────────────────────────────────────────────────────────────┤
│  Storage                                                       │
│    Drift DB (tibeb_drift.db) — 6 tables, schemaVersion 1     │
│      FK constraints ✅  WAL journal ✅  Cascade deletes ✅     │
│      ⚠️ No indices yet  ⚠️ No encryption                      │
│    SharedPreferences — reader settings, goals, flags          │
└──────────────────────────────────────────────────────────────┘
```

### Drift Schema — 6 Tables

| Table | Key Columns | FK Cascade | Notes |
|---|---|---|---|
| `books` | id, title, author, filePath, progress, audioTracks (JSON) | — | `isDeleted` soft-delete pattern |
| `reading_sessions` | id, bookId, date (yyyy-MM-dd), pagesRead, durationMinutes | ✅ CASCADE | |
| `bookmarks` | id, bookId, title, progress, position | ✅ CASCADE | |
| `quests` | id (text PK), title, type (enum), targetValue, currentValue, xpReward, date | — | No FK; quests are date-scoped |
| `highlights` | id, bookId, chapterIndex, text, note, color, position | ✅ CASCADE | `text` column named `textValue` in Dart |
| `dictionary_lookups` | id, bookId, word, timestamp | ✅ CASCADE | |

### SOLID Violations

| Principle | Violation | Location | Severity |
|---|---|---|---|
| **S** | `LibraryNotifier` handles books, XP, streaks, quests, achievements, bookmarks, goals, notifications, dictionary, filtering, sorting | `library_provider.dart` | 🔴 Critical |
| **S** | `_ReadingScreenState` handles EPUB parsing, PDF rendering, audio, search, bookmarks, highlights, orientation, battery, tutorial, progress | `reading_screen.dart` | 🔴 Critical |
| **O** | Format support requires modifying `processFile()` switch | `book_service.dart` | 🟡 High |
| **D** | `BookService` directly instantiates `DatabaseRepositoryImpl` (uses provider now, but service itself is still a non-injected singleton) | `book_service.dart` | 🟡 Medium |
| **I** | `LibraryState` has 40+ fields in one object | `library_provider.dart` | 🟡 High |

### Scalability Risks

1. **1,000+ books:** `getAllBooks()` loads ALL books via `SELECT *`. No indices on any column. No pagination.
2. **10,000+ highlights:** `getHighlightsForBook()` has no limit. Navigation sheet renders all.
3. **1 year of sessions:** `getAllReadingSessions()` loads ALL sessions for streak calculation. O(n) iteration.
4. **Large EPUBs:** `_processEpub()` calls `file.readAsBytes()` — entire file into RAM. A 200MB EPUB will OOM.
5. **MD5 hash:** `_calculateFileHash()` reads entire file bytes into memory. Large PDFs can crash.

---

## 4. Feature Status Matrix

> ✅ Complete | 🟡 Partial | ❌ Missing | ⚠️ Needs Redesign

### A. Format Support

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| EPUB | ✅ | 7/10 | CSS injection, chapter nav, full-text search, image rendering, internal links |
| PDF | ✅ | 7/10 | ColorFilter themes, text search, outline nav, programmatic page jump |
| CBZ/CBR | ❌ | — | No comic parser implemented |
| MOBI/AZW3 | ❌ | — | No Kindle format support |
| Markdown viewer | ❌ | — | `markdown` pkg in deps but unused for reading |
| HTML articles | ❌ | — | `webview_flutter` in deps but no article capture |

### B. Reading Experience

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Fast page turns | ✅ | 7/10 | `PageView.builder` — chapters preloaded; perceived ~16ms |
| Custom fonts | 🟡 | 5/10 | 4 fonts: Merriweather, Georgia, Lexend, System. **No Ethiopic font.** |
| Font weight control | ❌ | — | No slider exposed in settings |
| Letter/word spacing | ❌ | — | Not in `ReaderSettings` model |
| Margin control | ❌ | — | Hardcoded `EdgeInsets.fromLTRB(20,20,20,20)` in `epub_chapter_page.dart` |
| Line-height control | ✅ | 8/10 | Slider 1.0–2.5 in `DisplaySettingsSheet` |
| Hyphenation | ❌ | — | No `hyphens: auto` in CSS injection |
| Vertical scroll | ✅ | 7/10 | Default EPUB mode |
| Paginated mode | ❌ | — | Only vertical scroll; no true page-flip mode |
| RTL support | ❌ | — | Only `en_US` locale; no `Directionality` handling |
| Amharic script | 🟡 | 3/10 | Falls back to system font; **no bundled Ethiopic font in `assets/`** |
| Auto-scroll | ✅ | 7/10 | Ticker-based auto-scroll with speed control in `DisplaySettingsSheet` |

### C. Themes

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Light (White) | ✅ | 8/10 | `#FFFFFF` background |
| Sepia (Cream) | ✅ | 8/10 | `#F5F0E1` — close to brand parchment |
| Dark (Blue) | ✅ | 8/10 | `#1A2744` |
| AMOLED Black | ✅ | 8/10 | `#0A0B0E` |
| Publisher defaults | ✅ | 7/10 | Option in `DisplaySettingsSheet` to restore original EPUB styles |
| Auto sunrise/sunset | ❌ | — | No time-based automatic theme switching |

### D. Navigation

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Table of contents (EPUB) | ✅ | 7/10 | Tree-recursive widget in `navigation_sheet.dart`, auto-scrolls to current chapter |
| Table of contents (PDF) | ✅ | 7/10 | PDF outline tree via `pdfrx` |
| Full-text search (EPUB) | ✅ | 7/10 | Regex across all chapter HTML, up to 30 results |
| Full-text search (PDF) | ✅ | 7/10 | `PdfTextSearcher` with match highlighting |
| Progress slider | ✅ | 7/10 | Jump-to-percentage (EPUB) and jump-to-page (PDF) from navigation sheet |
| Chapter/page jump | ✅ | 7/10 | Text input in navigation sheet with keyboard submit |
| Orientation lock | ✅ | 7/10 | Toggle in reader bottom controls |
| Reading history trail | ❌ | — | No breadcrumb trail of recently visited positions |
| Cross-book search | ❌ | — | No "search all my books" feature |

### E. Annotation System

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Highlights (5 colors) | ✅ | 7/10 | Yellow, Green, Blue, Pink, Orange — stored in Drift DB, rendered via span injection |
| Rich text notes | ✅ | 7/10 | `flutter_quill` editor on each highlight; markdown storage |
| Bookmarks | ✅ | 7/10 | Chapter-level + scroll position, stored in Drift DB |
| Underline mode | ❌ | — | Only background highlight; no underline variant |
| Tag highlights | ❌ | — | No `tags` field on `Highlight` model or `highlights` table |
| Export highlights (per-book) | ✅ | 7/10 | Markdown export via `share_plus` from `NavigationSheet` |
| Export highlights (cross-book) | ❌ | — | No cross-book highlights browser or bulk export screen |
| Highlight review screen | ❌ | — | No standalone screen to review all highlights across all books |
| Color filter on highlights | ✅ | 7/10 | Filter bar in NavigationSheet's Annotations tab |
| Share as styled quote | ✅ | 7/10 | `ShareQuoteSheet` with book title/author credit |
| Vocabulary list | ✅ | 7/10 | Shown in NavigationSheet Annotations tab |

### F. Audiobook Integration

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| MP3 playback | ✅ | 8/10 | `just_audio`, multi-file, position resume |
| M4B support | 🟡 | 5/10 | Depends on `just_audio` codec; no explicit M4B handling |
| Variable speed | ✅ | 8/10 | 0.5×–2.0× in 0.25× steps via `AudioPlayer.setSpeed()` |
| Multi-track / chapter nav | ✅ | 8/10 | `ConcatenatingAudioSource`, reorderable track list sheet |
| Position resume | ✅ | 8/10 | Auto-save every 10 seconds; resume on reopen |
| Skip ±30s | ✅ | 8/10 | Implemented in `_skip()` in reading screen |
| Sleep timer | ❌ | — | Not implemented |
| Audio-text sync (Whispersync) | ❌ | — | No timestamp mapping between text position and audio |
| Offline playback | ✅ | 8/10 | Local files only; no streaming |

### G. Knowledge System

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Knowledge Graph | ❌ | — | Placeholder token class exists in theme; zero UI/logic |
| Second Brain queries | ❌ | — | No cross-book conceptual linking |
| Spaced repetition (flashcards) | ❌ | — | No flashcard model, algorithm, or UI |
| Vocabulary builder | 🟡 | 3/10 | `VocabularyLookup` model stores word only — **no definition, no context sentence** |
| Wisdom Timeline | ❌ | — | Not implemented |

### H. Sync & Reliability

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Offline-first | ✅ | 7/10 | Drift local database with WAL journal |
| Cloud sync | ❌ | — | Not implemented |
| Encrypted backup | ❌ | — | Plain-text Drift DB file; no at-rest encryption |
| Full data export | 🟡 | 3/10 | Per-book Markdown export only; no full JSON backup |
| Conflict resolution | ❌ | — | N/A until sync exists |
| Soft delete / restore | ✅ | 8/10 | `isDeleted=true` flag with hard-delete option; FK cascades clean up all child records |

### I. Gamification

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Reading streak | ✅ | 7/10 | Calculated from `reading_sessions` table; survives today + yesterday |
| Weekly goals | ✅ | 7/10 | Pages / minutes / XP goal types with editable target; `GoalSettingsSheet` |
| XP system | ✅ | 8/10 | 10 XP/page + 5 XP/min × time-of-day multipliers |
| Levels (1–99) | ✅ | 7/10 | `xp ~/ 1000 + 1`, capped at 99 |
| Ge'ez Ranks (6 tiers) | ✅ | 8/10 | Temari → Anebabi → Tsehafi → Liq → Baletibeb → Tibebawi |
| Rank-up celebration | ✅ | 8/10 | Animated `RankUpDialog` with pulsing gradient on tier change |
| 18 Achievements | ✅ | 7/10 | `AchievementsGrid` with tap-to-detail; sorted unlocked-first |
| 3 Daily Quests | ✅ | 7/10 | Pages/minutes/Early Bird; 2× XP on weekends; `DailyQuestsCard` |
| Quest XP rewarded | ✅ | 7/10 | Stored in `quests` Drift table, added to total XP |
| Monthly activity heatmap | ✅ | 7/10 | GitHub-style 5-level heatmap in `ActivityGraph` |
| Level info card | ✅ | 8/10 | `LevelInfoCard` with XP progress bar; taps open `LevelMetadataSheet` |
| Level metadata sheet | ✅ | 8/10 | All 6 ranks with level/achievements required + unlock status |
| Wisdom Timeline | ❌ | — | Not implemented |
| Monthly challenges | ❌ | — | No monthly challenge system |
| Leaderboards | ❌ | — | Intentionally excluded per product spec |

### J. AI Features

| Feature | Status | Priority |
|---|:---:|---|
| Passage explainer | ❌ | Phase 4 |
| Chapter summarizer | ❌ | Phase 4 |
| Flashcard auto-generation | ❌ | Phase 4 |
| Vocabulary lookup with definition | ❌ | Phase 4 |
| Cross-book AI search | ❌ | Phase 4 |
| "What did I learn about X?" | ❌ | Phase 4 |

### K. Ethiopian Advantage

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Bundled Amharic fonts | ❌ | — | **Zero** Ethiopic fonts in `assets/`. Only `app_icon.png` and `icon.png` are in assets. Abyssinica SIL not included. |
| Ge'ez rank names | ✅ | 9/10 | Authentic Ge'ez rank titles with descriptions |
| Amharic OCR | ❌ | — | No camera scanning or OCR pipeline |
| Amharic TTS | ❌ | — | No text-to-speech for Amharic |
| App localization (am/om/ti/so) | ❌ | — | Only `en_US` in `supportedLocales`; no `.arb` files |
| Ge'ez manuscript viewer | ❌ | — | No special renderer |
| Ethiopian author discovery | ❌ | — | No content store or discovery layer |
| Local reading challenges | ❌ | — | No Ethiopian-specific challenges defined |

### L. Universal Capture

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Receive shared files | ✅ | 6/10 | `receive_sharing_intent` wired in `main_navigation.dart` |
| Web article clipper | ❌ | — | `webview_flutter` in deps but no capture pipeline |
| Email/Tweet/Paper capture | ❌ | — | Not implemented |

---

## 5. Module-by-Module Code Audit

### 5.1 Models (`lib/models/`) — Score: 6/10

| File | LOC | Score | Key Issues |
|---|:---:|:---:|---|
| `book_model.dart` | 217 | 6/10 | Good `copyWith` with sentinel pattern. No `==`/`hashCode`. `audioTracks` stored as JSON string via `AudioTrackListConverter` (TypeConverter) — acceptable given Drift's typed support. |
| `highlight_model.dart` | 70 | 7/10 | Position format: `"chapterIdx:exact:matchIdx"` or `"chapterIdx:ratio"`. No `tags` field. Has `copyWith`. |
| `bookmark_model.dart` | 40 | 5/10 | **Missing `copyWith()`**. Minimal model. `toCompanion()` works via mapper extension. |
| `quest_model.dart` | 80 | 7/10 | Clean enum-based `QuestType`. Weekend 2× multiplier stored with quest. |
| `reader_settings_model.dart` | 185 | 7/10 | 4 themes with computed colors. 4 typefaces: Merriweather, Georgia, Lexend, System. Line height 1.0–2.5. No margin/spacing fields. |
| `vocabulary_model.dart` | 46 | 5/10 | Stores word + bookId + timestamp only. **No definition. No context sentence.** Essentially a lookup counter. |
| `search_result_model.dart` | 18 | 4/10 | `dynamic metadata` field — type-unsafe. No `toMap`/`fromMap`. |

**Model-wide issues:**
- No model uses `freezed`, `equatable`, or `operator ==` / `hashCode`. Riverpod `state ==` comparison may miss updates.
- `freezed_annotation`, `json_annotation`, `riverpod_annotation`, `go_router` and `freezed` are in `pubspec.yaml` but not yet fully activated in code — dead weight until properly implemented.

### 5.2 Database Layer (`lib/core/database/`) — Score: 8/10

| Component | LOC | Score | Notes |
|---|:---:|:---:|---|
| `tables.dart` | ~70 | 8/10 | 6 typed tables. FK with CASCADE. `@DataClassName` annotations. `audioTracks` uses `AudioTrackListConverter`. |
| `database.dart` | ~45 | 8/10 | `AppDatabase`, `schemaVersion: 1`, `PRAGMA foreign_keys = ON`, `PRAGMA journal_mode = WAL`. Background DB creation. |
| `audio_track_converter.dart` | ~20 | 8/10 | Clean `TypeConverter<List<AudioTrack>, String>` with try-catch fallback. |
| `BooksDao` | ~35 | 8/10 | Watch (reactive) + get, insert, update, soft/hard delete. Ordered by `addedAt DESC`. |
| `HighlightsDao` | ~35 | 8/10 | Watch + get, insert, update, delete single, delete for book. Ordered by `createdAt DESC`. |
| `BookmarksDao` | ~25 | 8/10 | Watch + get, insert, delete. |
| `QuestsDao` | ~30 | 7/10 | Get by date, insert, update progress, total XP sum. |
| `ReadingSessionsDao` | ~25 | 7/10 | Watch all, get all (no pagination — risk). |
| `DictionaryLookupsDao` | ~25 | 7/10 | Insert, get for book, count total. |

**Remaining DB concerns:**
- `schemaVersion: 1` — this is a fresh schema. Migration strategy is in place but empty (`onUpgrade` is a no-op). Any future schema change needs careful migration planning.
- **No indices defined on any table.** `BooksDao.getAllBooks()` does full table scan. Same for all DAOs.
- `getAllReadingSessions()` loads all rows — used for streak/stats calculation (O(n) risk at scale).
- `audioTracks` is still stored as a JSON string column rather than a separate `audio_tracks` table. This is mitigated by the TypeConverter but remains non-relational.

### 5.3 Repository Layer (`lib/core/repositories/`) — Score: 7/10

| Component | Score | Notes |
|---|:---:|---|
| `DatabaseRepository` (abstract) | 8/10 | Well-defined interface covering all 6 domains. `ReadingSessionEntity` leaks through the interface (should be `ReadingSession` domain model). |
| `DatabaseRepositoryImpl` | 7/10 | Clean delegation to DAOs. Good separation. `insertReadingSession` builds `ReadingSessionsCompanion` inline — minor violation of separation. |
| `mappers.dart` | 8/10 | Extension-method pattern keeps mapping logic co-located with entity/domain types. Comprehensive coverage. |

### 5.4 Providers (`lib/providers/`) — Score: 4/10

| File | LOC | Score | Notes |
|---|:---:|:---:|---|
| `library_provider.dart` | 1,538 | 3/10 | **God class.** 54 methods. `LibraryNotifier` handles: book CRUD, XP/level/streak calc, quest generation+update, achievement unlock, bookmark CRUD, dictionary lookup, filtering/sorting, goal management, notification scheduling, deferred notifications. `LibraryState` has 40+ fields. |
| `reader_settings_provider.dart` | 133 | 7/10 | Clean. 2-second debounced save to SharedPreferences. EPUB/PDF separate theme memory. |
| `database_providers.dart` | 17 | 9/10 | Clean. `databaseProvider` + `databaseRepositoryProvider`. Proper `ref.onDispose()` to close DB. |

**Recommended `LibraryNotifier` split:**
1. `LibraryNotifier` — Book CRUD, filtering, sorting, import
2. `GamificationNotifier` — XP, levels, streaks, achievements
3. `QuestNotifier` — Daily quest generation + progress
4. `AnnotationNotifier` — Highlights, bookmarks, vocabulary
5. `GoalNotifier` — Weekly goals, reading stats

### 5.5 Services (`lib/services/`) — Score: 5/10

| File | LOC | Score | Notes |
|---|:---:|:---:|---|
| `book_service.dart` | 202 | 5/10 | `_processEpub()` reads entire file into RAM (`file.readAsBytes()`). `_calculateFileHash()` reads entire file for MD5 — OOM risk. PDF gets no metadata extraction (title = filename). `downloadCover()` has no timeout or size limit. Direct `DatabaseRepository` dependency (injected via provider) — improved vs old direct instantiation. |
| `notification_service.dart` | 200 | 6/10 | Channels: engagement / reminders / boosts. Weekend 2× boost notifications Sat+Sun 10 AM. Daily reminder at user-set time. Notification tap handler doesn't route anywhere (no deep link). |

### 5.6 Screens (`lib/screens/`) — Score: 4/10

| File | LOC | Score | Notes |
|---|:---:|:---:|---|
| `reading_screen.dart` | ~2,515 | 3/10 | **God class.** EPUB init, PDF rendering, audio, search, bookmarks, highlights, orientation, battery, tutorial, heartbeat, progress sync, markdown export, dictionary lookup, navigation sheet. |
| `library_screen.dart` | 565 | 6/10 | Multi-select, batch tag, delete, import. Functional. |
| `dashboard_screen.dart` | 358 | 6/10 | Continue reading card, quick stats, heatmap, horizontal shelf. Uses `flutter_animate` on first load. |
| `stats_screen.dart` | 267 | 7/10 | `LevelInfoCard`, `WeeklyGoalCard`, `DailyQuestsCard`, `ActivityGraph`, `AchievementsGrid` — all proper widget delegation. |
| `settings_screen.dart` | 413 | 6/10 | Notifications on/off + time picker, app theme toggle (Light/Dark/System), donation + GitHub links, package info. |
| `edit_book_screen.dart` | 348 | 6/10 | Title/author/series/tags edit, audio track management, cover from file or Google image search. |
| `main_navigation.dart` | 353 | 6/10 | Glass bottom nav, `SharedAxisTransition`, sharing intent, first-launch tutorial, rank-up dialog listener. |
| `google_image_search_screen.dart` | 162 | 5/10 | WebView + JS injection intercept. Fragile (depends on Google DOM). |
| `file_selection_screen.dart` | 126 | 4/10 | **Not reachable from main navigation. Dead code or future use.** |

### 5.7 Reading Widgets (`lib/widgets/reading/`) — Score: 5/10

| File | LOC | Score | Notes |
|---|:---:|:---:|---|
| `epub_chapter_page.dart` | ~1,046 | 5/10 | CSS injection, highlight span injection (occurrence-index position encoding), image resolution from EPUB content map, overscroll chapter navigation, auto-scroll via Ticker, `SelectionArea` with custom context menu (5 color buttons + note + copy + dictionary + share). **God widget.** |
| `navigation_sheet.dart` | ~1,597 | 4/10 | 2 tabs: CHAPTERS (tree TOC + jump field) and ANNOTATIONS (bookmarks + highlights + vocabulary). Color filter bar. Selection mode + bulk delete. Export + share quote. **God widget — needs splitting into 4+ widgets.** |
| `pdf_view.dart` | ~264 | 6/10 | `PdfViewer.file` + `ColorFilter` matrix for themes. |
| `note_editor.dart` | ~302 | 6/10 | `QuillEditor` + `QuillSimpleToolbar`. 5-color picker on same sheet. |
| `reading_header.dart` | ~235 | 7/10 | Chapter title, live clock, battery level + icon, search toggle, lock toggle. |
| `reading_footer.dart` | ~155 | 7/10 | Draggable progress slider with chapter/page display. |
| `reading_bottom_controls.dart` | ~348 | 6/10 | Audio toggle, TOC, bookmark, auto-scroll, orientation, display settings. |
| `reading_audio_section.dart` | ~212 | 7/10 | Position slider, play/pause, skip ±30s, track title, speed display. |
| `share_quote_sheet.dart` | ~620 | 6/10 | Styled quote image preview + share. |
| `note_view.dart` | ~138 | 7/10 | Renders stored Quill markdown notes. |
| `epub_view.dart` | ~107 | 7/10 | `PageView.builder` of `EpubChapterPage`. |
| `reading_search_overlay.dart` | ~78 | 7/10 | Search bar + result list. |
| `play_pause_button.dart` | ~36 | 8/10 | Animated button. |
| `control_button.dart` | ~26 | 8/10 | Reusable icon button. |

### 5.8 Widget Subsystems — Score: 7/10

**`widgets/book_card/` (8 files — refactored):**
- `book_card.dart` — root widget delegating to sub-components
- `book_cover.dart` — cover image rendering
- `book_info.dart` — title/author/progress display
- `book_badges.dart` — status chips (favorite, format, finished)
- `book_progress_overlay.dart` — progress bar overlay
- `book_selection_overlay.dart` — multi-select UI
- `book_card_gesture_mixin.dart` — tap/long-press handling
- `book_card_helpers.dart` — utility functions

**`widgets/stats/` (5 files — well-separated):**
- `level_info_card.dart` — level + rank + XP progress bar; taps open metadata sheet
- `level_metadata_sheet.dart` — all 6 Ge'ez ranks with level/achievements requirements
- `weekly_goal_card.dart` — pages/minutes/XP goal progress
- `goal_settings_sheet.dart` — editable goal targets
- `achievements_grid.dart` — 18 achievement badges sorted unlocked-first, with tap-to-detail dialog

**`widgets/dashboard/` (3 files):**
- `continue_reading_card.dart` — last-read book with resume button
- `dashboard_header.dart` — greeting + quick stats
- `shelf_item.dart` — horizontal shelf book item

**`widgets/empty_state/`, `widgets/error_state/`, `widgets/loading/`:**
- Token infrastructure exists and is wired into the theme extension system.
- `empty_state.dart` only exports tokens — **no actual `EmptyState` widget implemented yet**.
- `error_state.dart` only exports tokens — **no actual `ErrorState` widget implemented yet**.
- These are scaffolded but the actual widget implementations are missing from the files.

### 5.9 Core Design System (`lib/core/theme/`) — Score: 7/10
- 50+ component token categories in `TibebThemeExtension`.
- Feature placeholder token classes exist for: AI, Audiobook, Dictionary, Download, Highlight, Knowledge Graph, Library, Notes, PDF Viewer, Reader, Search, Statistics, Sync — **all in place but some empty**.
- `TibebTheme.light()` and `TibebTheme.dark()` fully built.
- Brand color `#d4af37` (gold) not yet mapped to a named token — needs explicit `goldPrimary` token.

### 5.10 Gamification Core (`lib/core/rank/`) — Score: 8/10

**Rank System (authentic Ge'ez titles):**
| Rank | Ge'ez | Level Required | Achievements Required |
|---|---|:---:|:---:|
| Temari | ተማሪ | 1 | 0 |
| Anebabi | አነባቢ | 5 | 2 |
| Tsehafi | ፀሐፊ | 10 | 5 |
| Liq | ሊቅ | 20 | 8 |
| Baletibeb | ባለ ትብብ | 40 | 10 |
| Tibebawi | ትቤቡ | 50 | 12 |

**XP Multipliers (real logic in `_calculateStats`):**
- Base: 10 XP/page + 5 XP/minute
- 1.5× for sessions 6–9 AM (Early Bird)
- 1.5× for sessions 10 PM–1 AM (Night Owl)
- 2× for weekend sessions (Saturday/Sunday) — overrides time boosts
- Quest XP added from Drift `quests` table total

**18 Achievements (real, tracked in `LibraryState.unlockedAchievements`):**
First Page, Habit Builder, 7-Day Streak, Bookworm (1000p), Night Owl, Early Bird, Century Club (100p/session), Unstoppable (30-day streak), Marathoner (2h session), Scholar (5000p), Yomibito (10 books), Sensei (50 books), Bibliophile (10 in library), Collector (100 in library), Weekend Warrior, Word Seeker (1 lookup), Vocab Builder (20 lookups), Lexicoguru (100 lookups).

---

## 6. Technical Debt Register

### 🔴 Critical Priority

| Debt Item | Location | Impact | Estimated Effort |
|---|---|---|---|
| **God class: `_ReadingScreenState`** | `reading_screen.dart` (~2,515 LOC, 59 methods) | Every new reader feature (sleep timer, audio sync, new format) requires editing this monolith. Zero unit-test possibility. Merge conflicts guaranteed with >1 developer. | 2 weeks (split into EpubController, PdfController, AudioController, SearchManager, BookmarkManager, ProgressTracker) |
| **God class: `LibraryNotifier`** | `library_provider.dart` (1,538 LOC, 54 methods) | XP/streak/quest/goal/bookmark/notification logic all in one class. Impossible to test in isolation. Every change risks breaking 6 unrelated features. | 1.5 weeks (split into 5 notifiers as above) |
| **God widget: `navigation_sheet.dart`** | `widgets/reading/navigation_sheet.dart` (~1,597 LOC) | TOC tree + bookmarks + highlights + vocabulary + export + share + bulk actions all in one bottom sheet. Impossible to navigate or test. | 1 week (split into TocSheet, AnnotationsSheet, BookmarksList, HighlightsList, VocabularyChips) |
| **Zero test coverage** | `test/widget_test.dart` (default Flutter counter test only) | No regression safety. Any change is a deployment risk. Onboarding new developers is risky. | 2 weeks (build initial suite for DB/DAOs, models, XP calc, streak logic, quest generation) |

### 🟡 High Priority

| Debt Item | Location | Impact | Estimated Effort |
|---|---|---|---|
| **God widget: `epub_chapter_page.dart`** | `widgets/reading/epub_chapter_page.dart` (~1,046 LOC) | CSS injection + HTML processing + highlight regex + image resolution + selection handling + context menu + auto-scroll + overscroll in one widget. | 1 week (split into EpubHtmlProcessor, HighlightInjector, ImageResolver, SelectionHandler) |
| **No database indices** | `core/database/tables.dart` | Full table scans on every query. At 1,000+ books, startup will take 5+ seconds. | 1 day (add indices on `bookId`, `date`, `createdAt`, `isDeleted` via Drift `@TableIndex`) |
| **All sessions loaded for streak** | `ReadingSessionsDao.getAllReadingSessions()` | O(n) streak/stats calculation. With 1 year of daily sessions (~365 rows), startup stats calculation could take 1–3 seconds. | 1 day (add `getRecentSessions(int limit)` DAO method, use SQL `ORDER BY date DESC LIMIT 365`) |
| **All books loaded at startup** | `BooksDao.getAllBooks()` | Loads entire library into memory. No pagination. | 1–2 days (add `getRecentBooks(int limit)` + lazy-load rest) |
| **`BookService` reads entire files into memory** | `book_service.dart` | OOM crash on large files. A 200MB EPUB will crash. A 500MB PDF hash will crash. | 2–3 days (streaming hash with `md5.startChunkedConversion()`, chunked EPUB read) |
| **Hardcoded strings throughout** | All screens, `achievements_grid.dart`, quest descriptions, notification messages, rank names | Blocks localization to Amharic, Afaan Oromo, Tigrinya, Somali. | 3–5 days (extract to `.arb` files, add l10n codegen to pubspec) |
| **`freezed`, `go_router`, `riverpod_generator` in deps but unused** | `pubspec.yaml` | Dead weight. Confuses intent. Dependencies add build time without benefit. | 1 day (either implement codegen fully or remove unused deps) |

### 🟢 Medium Priority

| Debt Item | Location | Impact | Estimated Effort |
|---|---|---|---|
| No `equals`/`hashCode` on models | All 7 model classes | State comparison fails silently in Riverpod. May cause unnecessary rebuilds or miss updates. | 1 day (implement `operator ==` + `hashCode` on each, or add `equatable`) |
| `Bookmark` model lacks `copyWith()` | `bookmark_model.dart` | Inconsistent immutability pattern vs other models. | 30 min |
| `SearchResult.metadata` is `dynamic` | `search_result_model.dart` | Type-unsafe. Runtime errors if wrong type passed. | 30 min (make generic or use sealed union) |
| `FileSelectionScreen` unreachable | `screens/file_selection_screen.dart` | Dead code — not accessible from any navigation route. | 5 min (delete or document intent) |
| `downloadCover()` no timeout/size limit | `book_service.dart` | Can hang indefinitely or download a 100MB image. | 30 min (add `http.Client` with timeout, Content-Length check) |
| Empty/Error state widgets not implemented | `widgets/empty_state/`, `widgets/error_state/` | Token infrastructure exists but actual `EmptyState` and `ErrorState` widgets are stub exports. | 1 day (implement actual widgets using the token classes) |
| `LibraryState` leaks `ReadingSessionEntity` | `library_provider.dart` | Drift entity leaking into UI-layer state. Should use a domain model or pure data class. | 30 min (create `ReadingSession` domain model) |

---

## 7. Performance Analysis

| Issue | Location | Severity | Fix |
|---|---|:---:|---|
| **Entire EPUB file into RAM** | `book_service.dart:_processEpub()` | 🔴 | Stream-based reading or file size limit before load |
| **MD5 hash reads entire file** | `book_service.dart:_calculateFileHash()` | 🔴 | `md5.startChunkedConversion()` with file stream |
| **All books loaded at startup** | `BooksDao.getAllBooks()` | 🟡 | `LIMIT 50 ORDER BY lastReadAt DESC`; lazy-load rest |
| **All sessions loaded for streak** | `ReadingSessionsDao.getAllReadingSessions()` | 🟡 | Query: `ORDER BY date DESC LIMIT 365` |
| **No DB indices** | `core/database/tables.dart` | 🟡 | Add `@TableIndex` on `bookId`, `date`, `createdAt`, `isDeleted` |
| **Stats calc on full session set** | `library_provider.dart:_calculateStats()` | 🟡 | Move to background isolate; cache result |
| **`_applyFilters()` rebuilds full list** | `library_provider.dart` | 🟢 | Acceptable <500 books; needs optimization at scale |

### Startup Time Analysis (Current)

```
main() →
  WidgetsBinding.ensureInitialized()     ~2ms
  NotificationService().init()            ~50ms (permission check + channel setup)
  SharedPreferences.getInstance()         ~20ms
  ProviderScope → MaterialApp             ~5ms
  LibraryNotifier._init():
    _loadGoal() — SharedPreferences       ~5ms
    loadBooks():
      getAllBooks() — SELECT * books      ~50–500ms (scales with library size)
      getAllReadingSessions() — SELECT *  ~50–2000ms (scales with sessions count)
      _calculateStats() — iterates all    ~20–500ms
      _loadQuests()                       ~10ms
    notification scheduling               ~30ms
    Drift DB open + WAL init              ~30ms
```

**Risk:** With 500 books and 1 year of daily sessions, startup stats calculation could freeze the UI for 1–3 seconds before the first frame.

---

## 8. Security Audit

| Area | Status | Severity | Finding |
|---|:---:|:---:|---|
| **Local database** | 🔴 Insecure | Critical | Drift DB file (`tibeb_drift.db`) is completely unencrypted. Any app with root access can read all highlights, notes, and reading progress. |
| **Cover download** | 🟡 Risky | High | `downloadCover()` in `book_service.dart` downloads from arbitrary URLs with no TLS pinning, no size limit, no timeout. Potential for large-download attacks. |
| **File access** | 🟢 Good | Low | Uses `FilePicker` (SAF-based). No legacy `MANAGE_EXTERNAL_STORAGE` permission. |
| **Authentication** | 🔴 Missing | Critical | No user identity system. Required for any cloud feature or data backup. |
| **Secure storage** | 🔴 Missing | Critical | No `flutter_secure_storage`. All preferences in plain SharedPreferences XML. |
| **Network security** | 🟡 Missing | Medium | No certificate pinning. No `SecurityContext` configuration. `http` package used without client-level timeout. |
| **Input validation** | 🟡 Partial | Medium | `Book.fromMap()` does null-coalescing. Drift parameterized queries prevent SQL injection at query layer. |

### Security Recommendations
1. **Encrypt the Drift DB** — Use `drift` with `sqlcipher_flutter_libs` for at-rest encryption (~3–5 days). Generate encryption key, store in `flutter_secure_storage`.
2. **Add `flutter_secure_storage`** — For any future tokens/keys.
3. **Add request timeout** — All `http.get()` calls: `.timeout(Duration(seconds: 15))`.
4. **File size validation** — In `processFile()` before loading into RAM.
5. **When implementing auth** — Use OAuth2 PKCE flow, store tokens in `flutter_secure_storage` never in SharedPreferences.

---

## 9. UX Review

### Compared Against: Kindle · Readwise Reader · Kobo · Moon+ Reader · Audible

| Area | Tibeb | Kindle | Gap |
|---|---|---|---|
| Library grid | 2-column grid, cover + progress | Adaptive grid + list toggle | Missing list view toggle |
| Reading themes | 4 themes, instant switch | 4 themes + custom | On par |
| Font selection | 4 fonts (no Ethiopic) | 10+ including accessibility fonts | **Critical gap** — no Amharic/Ethiopic font |
| Font weight/margin/spacing | Not available | Full controls | Below Kindle standard |
| Highlight colors | 5 colors | 4 colors | **Exceeds Kindle** |
| Notes editor | Rich text (Quill) | Plain text | **Exceeds Kindle** — strong differentiator |
| Audio integration | Inline in reader with sync controls | Separate Audible app | **Innovative** — combined UX is novel |
| Knowledge review | None (vocab list only) | Readwise core feature | **Critical gap** for positioning |
| Gamification | XP, ranks, streaks, quests, achievements | None | **Exceeds all competitors** |
| Quote sharing | Styled image with book credit | Basic text share | **Exceeds Kindle** |
| Onboarding | Tutorial coach marks (4–6 targets) | Contextual tips | Acceptable |
| Error handling | None visible | Graceful recovery | Gap — corrupt file = silent crash |
| Settings UX | Basic single screen | Category-organized | Below average |

### UX Anti-Patterns Found

1. **No loading feedback during import:** Importing a large EPUB shows no progress. User doesn't know if it worked.
2. **No undo for delete:** Soft delete exists but no "Undo" toast appears after deletion.
3. **No library search:** Global text search only exists inside the reader, not from the library grid screen.
4. **Navigation sheet too dense:** TOC + Bookmarks + Highlights + Vocabulary + Export in one 70% height bottom sheet — overwhelming.
5. **Audio controls non-obvious:** Audio section expansion inside the reader bottom controls is non-obvious for new users.
6. **`FileSelectionScreen` is orphaned:** Unreachable from any navigation path — dead code or unfinished feature.

---

## 10. Accessibility Audit

| Area | Status | Notes |
|---|:---:|---|
| Screen reader (Semantics) | 🟡 Partial | No manual `Semantics` wrappers. Relies on Material widget defaults only. |
| Dynamic font scaling | 🟡 Partial | Reader has its own font size control. System-level font scaling may conflict. |
| Color contrast | ✅ Good | Dark themes have good contrast ratios (white text on dark backgrounds). |
| Touch target sizes | 🟡 Partial | Some icon buttons (e.g. in highlight context menu: ~36×36dp) may be below 48×48dp WCAG minimum. |
| Keyboard navigation | ❌ Missing | No `FocusNode` management for keyboard/D-pad navigation. |
| RTL layout | ❌ Missing | Only `en_US` locale. No `Directionality.of(context)` usage. |
| App localization | ❌ Missing | All strings hardcoded in English. No `.arb` files. No `AppLocalizations` setup. |
| Reading accessibility | 🟡 Partial | Line height and font size are user-controlled. No dyslexia font (OpenDyslexic). No Ethiopic font. |

---

## 11. Testing Audit

### Current State: 1/10

| Category | Count | Coverage |
|---|:---:|:---:|
| Unit tests | 0 | 0% |
| Widget tests | 1 (default Flutter counter) | 0% |
| Integration tests | 0 | 0% |
| E2E tests | 0 | 0% |

### Recommended Test Priorities

**Phase 1 — Foundation (Week 1):**
- Unit: Drift DAOs — CRUD operations with in-memory DB (`drift/native.dart` with `NativeDatabase.memory()`)
- Unit: `_calculateStreak()` — edge cases (no sessions, streak broken, yesterday-only)
- Unit: `_calculateStats()` — XP multipliers, level calculation, achievement thresholds
- Unit: `_generateDailyQuests()` — weekday vs weekend multiplier
- Unit: `BookService.processFile()` with mock EPUB/PDF bytes

**Phase 2 — State (Week 2):**
- `LibraryNotifier` state transitions (import → loadBooks → filtered state)
- `ReaderSettingsProvider` persistence round-trip with `SharedPreferences.setMockInitialValues()`
- Quest completion + XP update flow with mocked `DatabaseRepository`

**Phase 3 — Widget Tests (Week 3):**
- `BookCard` with various book states (unread, reading, finished, favorite)
- `AchievementsGrid` with mocked unlocked set
- `LevelInfoCard` with various XP values
- `DisplaySettingsSheet` interaction (theme change, font size slider)

**Phase 4 — Integration (Week 4):**
- Import → Read → Highlight → Export Markdown flow
- Audio: pick file → play → position save → resume
- XP accumulation → Level up → Rank tier change → Celebration dialog

---

## 12. Gap Analysis — What Must Be Built

### 🔴 Must Have Before Launch (MVP Blockers)

| Gap | Why Critical | Effort |
|---|---|---|
| **Error boundaries** | Corrupt EPUB/PDF currently crashes app silently. Users will uninstall. Implement actual `ErrorState` widget + `ErrorWidget.builder` globally. | 3–5 days |
| **Bundled Amharic font (Abyssinica SIL)** | Without it, the Ethiopian differentiator is literally invisible. Add to `assets/fonts/`, register in pubspec, add to typeface picker in `ReaderSettings.availableTypefaces`. | 1 day |
| **Highlight cross-book review screen** | The #1 "Readwise" differentiator is a screen where you review all highlights from all books. Currently only per-book export exists. | 3–5 days |
| **Sleep timer for audio** | Every audiobook user expects this. Simple `Timer` + `AudioPlayer.pause()`. Add time picker in audio controls. | 1–2 days |
| **Font weight + margin + spacing controls** | Needed to reach Kindle parity. Add fields to `ReaderSettings`, sliders to `DisplaySettingsSheet`. Inject into CSS. | 1–2 days |
| **Encrypted Drift DB** | Annotations are private. Use `drift` + `sqlcipher_flutter_libs`. Generate encryption key, store in `flutter_secure_storage`. | 3–5 days |
| **Full data backup/restore** | Users fear data loss. JSON export/import of all annotations + reading progress. Encrypted. | 3–5 days |
| **DB indices** | Required for performance at scale. Add `@TableIndex` on `bookId`, `date`, `createdAt`. | 1 day |

### 🟡 Should Have (v1.1 — 6 weeks post-launch)

| Gap | Why Important | Effort |
|---|---|---|
| **Cloud sync** | Multi-device users and #1 user anxiety ("what if I lose my phone?"). Build on Supabase/Firebase with offline-first conflict resolution. | 3+ weeks |
| **Spaced repetition flashcards** | Converts highlights into SM-2 algorithm review cards. "Anki inside your reader." | 1–2 weeks |
| **Tag highlights** | Add `tags` field to `Highlight` model, Drift migration, tag input in note editor, filter by tag in highlights browser. | 3–5 days |
| **App localization (Amharic first)** | Extract all strings to `.arb` files. Add `am` locale to `supportedLocales`. The single biggest trust signal for Ethiopian users. | 1–2 weeks |
| **CBZ/CBR comic support** | Extends the "all formats" promise. Use `archive` package for zip-based comics. | 3–5 days |
| **Auto sunrise/sunset theme** | Time-based reader theme switching. Add sunrise/sunset calculation to `ReaderSettingsNotifier`. | 1–2 days |
| **Hyphenation** | Add `hyphens: auto; -webkit-hyphens: auto;` to CSS injection in `epub_chapter_page.dart`. 30-minute fix for major typography improvement. | 30 min |
| **Cross-book full-text search** | "Show everything about leadership." Requires background indexing of all book content. Consider Drift FTS5. | 3–5 days |
| **Refactor god files** | Extract `GamificationNotifier`, `QuestNotifier` from `library_provider.dart`. Extract `EpubController`, `AudioController` from `reading_screen.dart`. | 2 weeks |
| **Implement EmptyState / ErrorState widgets** | Token infrastructure exists but actual widgets are stub exports. Complete the implementation. | 1 day |

### 🟢 Later (v2.0+ — The Vision)

| Gap | Why It Makes Tibeb Unique | Effort |
|---|---|---|
| **Knowledge Graph** | Books → People → Concepts → Quotes → Ideas linked across your entire library. "Obsidian for readers." | 3+ weeks |
| **AI passage explainer (Gemini)** | Select text → tap → get explanation + related highlights from your own library. | 3–5 days (API integration) |
| **Amharic TTS** | Read aloud in Amharic using on-device TTS. Kindle doesn't do this. | 1–2 weeks |
| **Amharic OCR** | Camera → scan a printed Amharic book → import as searchable text. | 1–2 weeks |
| **Audio-text sync (Whispersync)** | Map audio chapter timestamps to EPUB chapter positions. Auto-switch on play/pause. | 3+ weeks |
| **Universal web capture** | Browser extension or share-to → article saved as ebook in Tibeb. | 1–2 weeks |
| **MOBI/AZW3 import** | Kindle file compatibility. Requires format conversion pipeline. | 3–5 days |
| **Ethiopian book marketplace** | Curated Ethiopian author discovery + download. The ultimate moat. | 3+ months |
| **Plugin/extension system** | Third-party integrations (Notion, Obsidian, Anki export). | 3+ weeks |
| **Social reading circles** | Private shared libraries + annotation sharing. | 3+ weeks |

---

## 13. Production Readiness Checklist

| Subsystem | Ready? | Blocker | Action Required |
|---|:---:|---|---|
| Reading engine (EPUB) | 🟡 | Crashes on corrupt files | Add `ErrorWidget.builder` + try-catch with user-facing error screen |
| Reading engine (PDF) | 🟡 | Same as above | Add error boundaries |
| Audio playback | 🟡 | No sleep timer | Implement `Timer` + auto-pause (1-2 days) |
| Storage (Drift DB) | 🟡 | Unencrypted, no indices | Add encryption via sqlcipher + add indices (5 days) |
| Annotation system | 🟡 | No tags, no cross-book view | Add tags field + review screen (5 days) |
| Gamification | ✅ | — | **Production ready** |
| Sync | ❌ | Not implemented | **Blocks multi-device users** (3+ weeks) |
| Offline support | 🟡 | Works but no backup | Add encrypted JSON export/import (3-5 days) |
| Auth | ❌ | Not implemented | **Required for sync** (1 week) |
| Performance | 🟡 | OOM risk on large files; no indices | Streaming hash, chunked EPUB read, add indices (3 days) |
| Security | ❌ | Plain-text DB, no secrets management | Encrypt Drift DB + flutter_secure_storage (5 days) |
| Error handling | ❌ | No global boundaries | `ErrorWidget.builder` + Sentry/Crashlytics (3 days) |
| Monitoring / Analytics | ❌ | No visibility | Firebase Analytics / Mixpanel (2 days) |
| Logging | ❌ | `debugPrint()` only | Structured logging with `logger` package (1 day) |
| Testing | ❌ | 0% coverage | Minimum 60% before launch (2 weeks) |
| CI/CD | ❌ | No pipeline | GitHub Actions: lint → test → build (1 day) |
| Accessibility | ❌ | No Semantics, no l10n | Add Semantics + `.arb` files (1 week) |
| Deep linking | ❌ | `go_router` in deps but unused | Wire up `go_router` for deep link support (3 days) |
| Amharic font | ❌ | Not in `assets/` | Add Abyssinica SIL font (1 day) |

---

## 14. Prioritized Roadmap

### Phase 1 — Stabilization (Weeks 1–2)

**Goal:** Make the app safe to ship without data loss or crashes.

- [x] **Add error boundaries** — `ErrorWidget.builder` globally. Implement actual `ErrorState` widget using existing token infrastructure. Try-catch wrappers on EPUB/PDF parsing with user-facing error screen ("This file is corrupted. Try re-importing.").
- [ ] **Fix OOM risks** — Use `md5.startChunkedConversion()` with file stream for hashing. Add max file size limit before loading EPUBs into RAM (e.g., 50MB soft limit with user warning).
- [ ] **Add Drift DB indices** — Use `@TableIndex` annotation in `tables.dart` on: `bookmarks.bookId`, `highlights.bookId`, `reading_sessions.bookId`, `reading_sessions.date`, `dictionary_lookups.bookId`.
- [ ] **Optimize session loading** — Add `getRecentSessions(int limit)` to `ReadingSessionsDao` querying `ORDER BY date DESC LIMIT 365`. Use this for streak calculation.
- [ ] **Set up CI/CD** — GitHub Actions workflow: `flutter analyze`, `flutter test` (even if minimal), `flutter build apk --release`.
- [x] **Implement EmptyState and ErrorState widgets** — Complete the scaffolded widget files using the existing token infrastructure.
- [ ] **Delete orphaned `file_selection_screen.dart`** — Or document its future purpose and add a route for it.

**Success Metrics:** Zero crashes on corrupt files. Startup time <1s for libraries <100 books. CI pipeline passes on every PR.

---

### Phase 2 — MVP Completion (Weeks 3–6)

**Goal:** Ship v1.0 with differentiated features ready for public launch.

- [ ] **Bundle Abyssinica SIL font** — Add to `assets/fonts/`, register in `pubspec.yaml` under `flutter.fonts`, add to `ReaderSettings.availableTypefaces`.
- [ ] **Highlight cross-book browser** — New screen: `AllHighlightsScreen`. List all highlights across all books with search, filter by color/book, export all as Markdown. Add new `DatabaseRepository` method: `getAllHighlights()`.
- [ ] **Sleep timer** — Add `Timer` to `_ReadingScreenState`, time picker in audio controls (5/10/15/30/60 min), auto-pause on timer expiry with notification.
- [ ] **Tag highlights** — Add `tags` field to `Highlight` model. Add `tags` column to Drift `Highlights` table. Handle migration via `onUpgrade`. Tag input in `NoteEditor`. Filter by tag in `NavigationSheet` highlights tab.
- [ ] **Font weight + margin + spacing controls** — Add `fontWeight`, `marginHorizontal`, `letterSpacing` fields to `ReaderSettings`. Add sliders to `DisplaySettingsSheet`. Inject into CSS template in `epub_chapter_page.dart`.
- [ ] **Hyphenation** — Inject `hyphens: auto; -webkit-hyphens: auto;` into `<body>` CSS in `epub_chapter_page.dart`. Test on English + Amharic.
- [ ] **Encrypt Drift DB** — Add `sqlcipher_flutter_libs` dependency. Update `_openConnection()` in `database.dart` to use encrypted backend. Generate encryption key, store in `flutter_secure_storage`.
- [ ] **Encrypted local backup** — JSON export/import of all 6 Drift tables. AES encryption with user passphrase. Accessible from Settings screen.
- [ ] **Basic test suite** — 40% coverage target: Drift DAO CRUD tests (in-memory DB), `_calculateStreak()`, `_calculateStats()`, `_generateDailyQuests()`.
- [ ] **First localization** — Amharic `.arb` file with all hardcoded strings extracted. Add `am` to `supportedLocales` in `main.dart`.

**Success Metrics:** App is shippable to Ethiopian users. Highlights can be reviewed across all books. Data backup/restore works. Core logic is tested.

---

### Phase 3 — Differentiation (Weeks 7–14)

**Goal:** Build the features that make Tibeb unique vs Kindle/Kobo.

- [ ] **Refactor god files** — Extract `GamificationNotifier`, `QuestNotifier`, `AnnotationNotifier`, `GoalNotifier` from `library_provider.dart`. Extract `EpubController`, `PdfController`, `AudioController`, `SearchManager` from `reading_screen.dart`. Split `navigation_sheet.dart` into 4 focused bottom sheets.
- [ ] **Cloud sync** — Supabase backend with offline-first `sync_queue` Drift table. Conflict resolution: last-write-wins with timestamp per entity.
- [ ] **Spaced repetition flashcards** — `Flashcard` domain model. `FlashcardNotifier`. SM-2 algorithm for review scheduling. "Convert to flashcard" button on highlights. New Drift table: `flashcards`.
- [ ] **Wire up `go_router`** — Replace all `Navigator.push()` with `go_router` routes. Add deep links for: `/book/:id`, `/highlights`, `/stats`, `/reading/:bookId`.
- [ ] **Cross-book search** — Background isolate to index all book content. Drift FTS5 virtual table. "Search my library" screen accessible from library header.
- [ ] **Auto sunrise/sunset theme** — Add `sunrise_sunset` package. Calculate local sunrise/sunset times. Auto-switch reader theme at those times.
- [ ] **CBZ/CBR support** — Add `ComicReaderScreen`. Use `archive` package to extract images from zip/rar. Page-flip UI with image rendering.
- [ ] **App localization expansion** — Add Afaan Oromo, Tigrinya, Somali localizations with native speaker review.
- [ ] **Analytics integration** — Firebase Analytics / Mixpanel. Track: books imported, highlights created, audio usage, quest completion, level ups.

**Success Metrics:** Cloud sync works without data loss. Users can create flashcards from highlights. Cross-book search works. Localization ships with at least 2 languages beyond English.

---

### Phase 4 — The Vision (Weeks 15+)

**Goal:** Build "Kindle + Readwise + Obsidian + Audible + Anki" in one app.

- [ ] **Knowledge Graph** — Entity extraction from highlights. Link concepts/people/ideas across books. Graph visualization with `graphview` package.
- [ ] **AI passage explainer** — Gemini API integration. Select text → call API with context → display explanation + related highlights from user's library.
- [ ] **Audio-text sync (Whispersync)** — Map audio timestamps to EPUB chapter/offset. Auto-jump text position on audio play. Auto-jump audio on text scroll.
- [ ] **Amharic TTS** — On-device TTS with Amharic voice pack. Read-aloud button in reader.
- [ ] **Amharic OCR** — `google_mlkit_text_recognition` with Amharic script support. Camera screen → scan → import as searchable text book.
- [ ] **Universal capture** — Chrome/Firefox extension for web articles. Share-to-Tibeb from Twitter/Telegram. Convert to EPUB, import.
- [ ] **MOBI/AZW3 import** — Add `mobi_dart` package or conversion pipeline. Import Kindle books.
- [ ] **Plugin system** — `TibebPlugin` abstract class. Third-party plugins for Notion export, Obsidian sync, Anki flashcard sync, Goodreads integration.
- [ ] **Social reading circles** — Private shared libraries. Annotation sharing with attribution. Reading challenge groups.
- [ ] **Ethiopian book marketplace** — Curated content store with Ethiopian authors. Buy/download directly in-app.
- [ ] **Public API** — Developer API with OAuth2 for third-party integrations.

**Success Metrics:** Users report "I never need another reading app." Knowledge graph generates useful cross-book insights. Ethiopian authors have a distribution channel.

---

## Final Verdict

### What Has Been Accomplished Since the First Audit
The Drift migration is a significant quality improvement:
- **Typed schema** replaces raw SQL strings.
- **DAO pattern** provides a clean query layer.
- **Repository abstraction** (`DatabaseRepository`) decouples business logic from storage.
- **FK constraints + CASCADE deletes** enforce data integrity at the DB layer.
- **WAL journal** improves write concurrency.
- **Widget decomposition** started — `book_card/` refactored into 8 files, `widgets/stats/` into 5 focused widgets.

### What Is Still Blocking Launch
- **God files** block scaling the team or features.
- **No sync** means users fear data loss.
- **Zero tests** mean every change is risky.
- **No Amharic font bundled** despite Ethiopian positioning — assets directory has only app icons.
- **Plain-text Drift DB** is a privacy risk.
- **No error boundaries** — any corrupt EPUB or PDF will crash the app silently.

### Strategic Recommendation
**6-week intensive sprint to v1.0:**
- Weeks 1–2: Stabilize (error boundaries, DB indices, OOM fixes, CI, EmptyState/ErrorState widgets).
- Weeks 3–6: Complete MVP (Amharic font, highlight browser, sleep timer, DB encryption, basic tests, Amharic localization).

After these 6 weeks, Tibeb delivers on its core promise:
> "Kindle + Readwise + Audible for Ethiopian readers, with gamification that makes reading addictive."

Then launch publicly, collect user feedback, and build Phase 3 (sync + flashcards + cross-book search) based on real usage data.

The knowledge graph and AI features (Phase 4) are 6+ months out — don't block launch on them.

---

**End of Audit** — Generated 2026-07-07 | Supersedes `TIBEB_AUDIT.md` and `TIBEB_COMPREHENSIVE_AUDIT.md`
