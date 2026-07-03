# 🔬 Tibeb — Comprehensive Engineering & Product Audit
> **Auditor:** Principal Architect · Senior Mobile Engineer · UX Expert · Product Manager
> **Date:** 2026-07-03 | **Flutter SDK:** ^3.10.7 | **Dart:** 3.x
> **Platform:** Android (primary) | **DB:** SQLite v18 | **State:** Riverpod 3
> **Codebase:** 78 Dart files | ~18,000 LOC | 3 services | 2 providers | 7 models | 14 reading widgets
> **Vision:** Kindle + Readwise + Obsidian + Audible, built for Ethiopian & global readers

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Brand & Color System](#2-brand--color-system)
3. [Feature Status Matrix — Complete](#3-feature-status-matrix)
4. [Architecture Deep Dive](#4-architecture-deep-dive)
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

### Overall Health Score: 4.5 / 10

| Dimension | Score | Assessment |
|---|:---:|---|
| **Architecture Maturity** | 3/10 | Two god-class files block all scaling |
| **Production Readiness** | 3/10 | No sync, no auth, no encryption, no error boundaries |
| **Feature Completeness (MVP)** | 5/10 | EPUB/PDF/Audio/Gamification work; Knowledge System absent |
| **Code Quality** | 4/10 | Functional but severely coupled, god files, zero tests |
| **Performance** | 5/10 | Good for <200 books; will degrade badly at scale |
| **Security** | 2/10 | Plain-text SQLite, no secure storage, no auth |
| **UX/Design** | 6/10 | Clean aesthetic, good reading themes; some flows unpolished |
| **Testing** | 1/10 | Only the default counter widget test exists |
| **CI/CD** | 0/10 | No pipeline, no linting enforcement, no automated builds |

### Major Strengths (What Is Actually Good)
- **Gamification System:** XP with time-of-day multipliers, 6 Ge'ez-themed ranks (Temari→Tibebawi), 18 achievements, 3 daily quests with weekend 2× multiplier, reading streak tracking — a genuine differentiator.
- **EPUB Rendering:** Custom `PageView.builder` per chapter, HTML CSS injection, 5-color highlight span injection via regex, image resolution from EPUB content map, overscroll chapter flip with haptic feedback, auto-scroll via Ticker.
- **PDF Rendering:** `pdfrx` with `ColorFilter` matrix per theme, `PdfTextSearcher` full-text search with result highlighting, outline navigation, programmatic page jumping.
- **Audiobook Integration:** `just_audio` with `ConcatenatingAudioSource` (multi-track), variable speed, track reordering, 10-second position auto-save, resume from last position.
- **Design System:** Token-based with 50+ themed component categories, feature placeholders for AI/Knowledge Graph/Sync already scaffolded.
- **File Import Pipeline:** SAF-based `FilePicker`, MD5 deduplication, EPUB metadata + cover extraction, soft-delete pattern.

### Highest-Priority Issues (The Blockers)

| # | Issue | Impact | Estimated Effort |
|---|---|---|---|
| 1 | **No cloud sync/backup** | Total data loss on device change | 3+ weeks |
| 2 | **God files** (reading_screen.dart 2,515 LOC; library_provider.dart 1,538 LOC) | Unmaintainable; blocks all new feature work | 2 weeks |
| 3 | **Zero test coverage** | Any change is a regression risk | 2 weeks |
| 4 | **No error boundaries** | App crashes on corrupt EPUB/PDF silently | 3–5 days |
| 5 | **Plain-text SQLite** | Annotations readable by root apps | 3–5 days |

---

## 2. Brand & Color System

### Brand Palette (User-Defined)
| Token | Hex | Usage |
|---|---|---|
| Deep Navy | `#0d1321` | App background (dark mode base) |
| Warm Brown | `#3b2f2f` | Surface containers, cards |
| Bronze | `#6b4e16` | Secondary surfaces, borders |
| Gold | `#d4af37` | **Primary accent** — XP, streaks, highlights |
| Parchment | `#e7d9b5` | Sepia reader background, warm tones |
| Cream | `#f7f3e6` | Light reader background |

### Reader Themes (Currently Implemented)
| Theme ID | Background | Text | Usage |
|---|---|---|---|
| `white` | `#FFFFFF` | `#1A1A1A` | Bright light mode |
| `cream` | `#F5F0E1` | `#333333` | Warm sepia (close to brand `#f7f3e6`) |
| `darkBlue` | `#1A2744` | `#E0E0E0` | Dark blue night mode |
| `black` | `#0A0B0E` | `#FFFFFF` | AMOLED black (close to brand `#0d1321`) |

### Highlight Colors (Reader)
5 colors from `TibebThemeExtension.highlightColors`:
Yellow, Green, Blue, Pink, Orange — mapped to `reader.highlightYellow`, `reader.highlightGreen`, etc.

### Gap: Brand Colors Not Fully Applied
- `#d4af37` (Gold) is the natural XP/accent color but the theme uses `colorSystem.secondary` as accent — needs explicit gold token.
- `#3b2f2f` (Warm Brown) / `#6b4e16` (Bronze) not present as named design tokens.
- The parchment `#e7d9b5` and cream `#f7f3e6` should align exactly with reader cream theme.

---

## 3. Feature Status Matrix

> ✅ Complete | 🟡 Partial | ❌ Missing | ⚠️ Needs Redesign

### A. Format Support

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| EPUB | ✅ | 7/10 | CSS injection, chapter nav, full-text search, image rendering, internal links |
| PDF | ✅ | 7/10 | ColorFilter themes, text search, outline nav, programmatic page jump |
| CBZ/CBR | ❌ | — | No comic parser implemented |
| MOBI/AZW3 import | ❌ | — | No Kindle format support |
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
| Line-height control | ✅ | 8/10 | Slider 1.0–2.5 in DisplaySettingsSheet |
| Hyphenation | ❌ | — | No `hyphens: auto` in CSS injection |
| Vertical scroll | ✅ | 7/10 | Default EPUB mode |
| Paginated mode | ❌ | — | Only vertical scroll; no true page-flip mode |
| RTL support | ❌ | — | Only `en_US` locale; no `Directionality` handling |
| Amharic script | 🟡 | 3/10 | Falls back to system font; no bundled Ethiopic font in `assets/` |

### C. Themes

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Light (White) | ✅ | 8/10 | `#FFFFFF` background |
| Sepia (Cream) | ✅ | 8/10 | `#F5F0E1` — close to brand parchment |
| Dark (Blue) | ✅ | 8/10 | `#1A2744` |
| AMOLED Black | ✅ | 8/10 | `#0A0B0E` |
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
| Reading history trail | ❌ | — | No breadcrumb trail of recently visited positions |
| Cross-book search | ❌ | — | No "search all my books" feature |

### E. Annotation System

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Highlights (5 colors) | ✅ | 7/10 | Yellow, Green, Blue, Pink, Orange — stored in SQLite, rendered via span injection |
| Rich text notes | ✅ | 7/10 | `flutter_quill` editor on each highlight; markdown storage |
| Bookmarks | ✅ | 7/10 | Chapter-level + scroll position, stored in DB |
| Underline mode | ❌ | — | Only background highlight; no underline variant |
| Tag highlights | ❌ | — | No `tags` field on `Highlight` model |
| Export highlights (per-book) | ✅ | 7/10 | Markdown export via `share_plus` from NavigationSheet or ReadingScreen |
| Export highlights (cross-book) | ❌ | — | No cross-book highlights browser or bulk export screen |
| Highlight review screen | ❌ | — | No standalone screen to review all highlights across all books |
| Color filter on highlights | ✅ | 7/10 | Filter bar in NavigationSheet's Annotations tab |
| Share as styled quote | ✅ | 7/10 | `ShareQuoteSheet` with book title/author credit |

### F. Audiobook Integration

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| MP3 playback | ✅ | 8/10 | `just_audio`, multi-file, position resume |
| M4B support | 🟡 | 5/10 | Depends on `just_audio` codec; no explicit M4B handling |
| Variable speed | ✅ | 8/10 | 0.5×–2.0× in 0.25× steps via `AudioPlayer.setSpeed()` |
| Multi-track / chapter nav | ✅ | 8/10 | `ConcatenatingAudioSource`, reorderable track list sheet |
| Position resume | ✅ | 8/10 | Auto-save every 10 seconds; resume on reopen |
| Skip ±30s | ✅ | 8/10 | Implemented in `_skip()` |
| Sleep timer | ❌ | — | Not implemented |
| Audio-text sync (Whispersync) | ❌ | — | No timestamp mapping between text position and audio |
| Offline playback | ✅ | 8/10 | Local files only; no streaming |

### G. Knowledge System

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Knowledge Graph | ❌ | — | Placeholder token class exists in theme; zero UI/logic |
| Second Brain queries | ❌ | — | No cross-book conceptual linking |
| Spaced repetition (flashcards) | ❌ | — | No flashcard model, algorithm, or UI |
| Vocabulary builder | 🟡 | 3/10 | `VocabularyLookup` model stores word only (no definition, no context sentence) |
| Wisdom Timeline | ❌ | — | Not implemented |

### H. Sync & Reliability

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Offline-first | ✅ | 6/10 | SQLite local database |
| Cloud sync | ❌ | — | Not implemented |
| Encrypted backup | ❌ | — | Plain-text SQLite, no at-rest encryption |
| Full data export | 🟡 | 3/10 | Per-book Markdown export only; no full JSON backup |
| Conflict resolution | ❌ | — | Not applicable until sync exists |
| Soft delete / restore | ✅ | 7/10 | `isDeleted=1` flag with hard-delete option |

### I. Gamification

| Feature | Status | Quality | Notes |
|---|:---:|:---:|---|
| Reading streak | ✅ | 7/10 | Calculated from `reading_sessions` table; survives today + yesterday |
| Weekly goals | ✅ | 7/10 | Pages / minutes / XP goal types with editable target |
| XP system | ✅ | 8/10 | 10XP/page + 5XP/min × time-of-day multipliers (1.5× early/night, 2× weekend) |
| Levels (1–99) | ✅ | 7/10 | `xp ~/ 1000 + 1`, capped at 99 |
| Ge'ez Ranks (6 tiers) | ✅ | 8/10 | Temari → Anebabi → Tsehafi → Liq → Baletibeb → Tibebawi |
| Rank-up celebration | ✅ | 8/10 | Animated dialog with pulsing gradient on tier change |
| 18 Achievements | ✅ | 7/10 | Milestone badges + time-of-day + vocabulary achievements |
| 3 Daily Quests | ✅ | 7/10 | Pages/minutes/Early Bird; 2× XP on weekends |
| Quest XP rewarded | ✅ | 7/10 | Stored in `quests` table, added to total XP |
| Monthly activity heatmap | ✅ | 7/10 | GitHub-style 5-level heatmap |
| Wisdom Timeline | ❌ | — | Not implemented |
| Monthly challenges | ❌ | — | No monthly challenge system |
| Leaderboards | ❌ | — | Not implemented (correct: avoided per spec) |

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
| Bundled Amharic fonts | ❌ | — | **Zero** Ethiopic fonts in `assets/`. Abyssinica SIL not included. |
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
| Browser extension | ❌ | — | Out of scope for mobile |

---

## 4. Architecture Deep Dive

### Current Architecture Diagram

```
┌──────────────────────────────────────────────────────────┐
│  UI Layer                                                  │
│  screens/ (9 files) + widgets/ (14 reading, 10 other)     │
│  components/ (11 files)                                    │
│                                                            │
│  GOD FILE: reading_screen.dart (2,515 LOC, 59 methods)    │
│  GOD FILE: navigation_sheet.dart (1,597 LOC)              │
│  LARGE: epub_chapter_page.dart (1,046 LOC)                │
├──────────────────────────────────────────────────────────┤
│  State Layer (Riverpod)                                    │
│  GOD FILE: library_provider.dart (1,538 LOC, 54 methods) │
│  CLEAN: reader_settings_provider.dart (133 LOC)           │
│  SIMPLE: currentlyReadingProvider (StateProvider<Book?>)  │
│  SIMPLE: navigationStateProvider (StateProvider)          │
│  CLEAN: themeModeProvider (NotifierProvider)              │
├──────────────────────────────────────────────────────────┤
│  Service Layer                                             │
│  database_service.dart (473 LOC) — Singleton              │
│  book_service.dart (202 LOC) — Singleton                  │
│  notification_service.dart (200 LOC) — Singleton          │
├──────────────────────────────────────────────────────────┤
│  Model Layer (7 models)                                    │
│  book, bookmark, highlight, quest,                         │
│  reader_settings, search_result, vocabulary                │
├──────────────────────────────────────────────────────────┤
│  Core                                                      │
│  rank/ (5 files) — 6 Ge'ez rank tiers                     │
│  theme/ (~80 files) — Token-based design system           │
├──────────────────────────────────────────────────────────┤
│  Storage                                                   │
│  SQLite v18 — 6 tables, 18 migrations, NO indices         │
│  SharedPreferences — reader settings, goals, flags        │
└──────────────────────────────────────────────────────────┘
```

### SOLID Violations

| Principle | Violation | Location | Severity |
|---|---|---|---|
| **S** — Single Responsibility | `LibraryNotifier` handles books, XP, streaks, quests, achievements, bookmarks, goals, notifications, dictionary, filtering, sorting | `library_provider.dart` | 🔴 Critical |
| **S** — Single Responsibility | `_ReadingScreenState` handles EPUB parsing, PDF rendering, audio, search, bookmarks, highlights, orientation, battery, tutorial, progress | `reading_screen.dart` | 🔴 Critical |
| **O** — Open/Closed | Format support requires modifying `processFile()` switch | `book_service.dart:16-24` | 🟡 High |
| **D** — Dependency Inversion | `BookService` directly instantiates `DatabaseService()` | `book_service.dart:14` | 🟡 High |
| **I** — Interface Segregation | `LibraryState` has 40+ fields in one object | `library_provider.dart:35-265` | 🟡 High |

### Scalability Risks

1. **1,000+ books:** `getBooks()` loads ALL books with `SELECT *`. No indices. No pagination.
2. **10,000+ highlights:** `getHighlightsForBook()` has no limit. Navigation sheet renders all.
3. **1 year of sessions:** `getReadingSessions()` loads ALL sessions for streak calculation.
4. **Large EPUBs:** `_processEpub()` calls `file.readAsBytes()` — entire file into RAM. A 200MB EPUB will OOM.
5. **MD5 hash:** `_calculateFileHash()` reads entire file bytes into memory. Large PDFs will crash.

### Recommended Target Architecture (for refactor)

```
Feature-first clean architecture:
  features/
    library/   → BookRepository (abstract) + SQLiteBookRepository
    reader/    → EpubController, PdfController, AudioController (separate)
    knowledge/ → HighlightRepository, FlashcardService
    stats/     → GamificationNotifier (XP/levels/streaks)
    quests/    → QuestNotifier
    sync/      → SyncService (future)
  core/
    database/  → DatabaseService (repository interfaces)
    network/   → ApiClient (future)
```

---

## 5. Module-by-Module Code Audit

### 5.1 Models — Score: 6/10

| File | LOC | Score | Status | Key Issues |
|---|:---:|:---:|:---:|---|
| `book_model.dart` | 217 | 6/10 | ✅ Real | Good `copyWith` with sentinel pattern. No `==`/`hashCode`. Audio tracks stored as JSON string in books table (anti-pattern). |
| `highlight_model.dart` | 70 | 7/10 | ✅ Real | Position format: `"chapterIdx:exact:matchIdx"` or `"chapterIdx:ratio"`. No `tags` field. Has `copyWith`. |
| `bookmark_model.dart` | 40 | 5/10 | ✅ Real | **Missing `copyWith()`**. Minimal model. |
| `quest_model.dart` | 80 | 7/10 | ✅ Real | Clean enum-based quest types. Weekend 2× multiplier data stored with quest. |
| `reader_settings_model.dart` | 185 | 7/10 | ✅ Real | 4 themes with computed colors. 4 typefaces: Merriweather, Georgia, Lexend, System. Line height 1.0–2.5. No margin/spacing fields. |
| `vocabulary_model.dart` | 46 | 5/10 | 🟡 Partial | Stores word + bookId + timestamp only. **No definition. No context sentence.** Essentially a lookup counter. |
| `search_result_model.dart` | 18 | 4/10 | 🟡 Partial | `dynamic metadata` field — type-unsafe. No `toMap`/`fromMap`. |

**Model-wide issues:**
- No model uses `freezed`, `equatable`, or `operator ==` / `hashCode`. Riverpod `state ==` comparison may miss updates.
- `audioTracks` JSON-serialized inside `books` table column — should be a separate `audio_tracks` table.

### 5.2 Services — Score: 5/10

| File | LOC | Score | Status | Key Issues |
|---|:---:|:---:|:---:|---|
| `database_service.dart` | 473 | 5/10 | ✅ Real | 18 sequential migrations work but brittle. **No indices on any column.** No `FOREIGN KEY` constraints. `getBooks()` loads ALL books. `getReadingSessions()` loads ALL sessions. `hardDeleteBook` uses transaction (good). |
| `book_service.dart` | 202 | 5/10 | ✅ Real | `_processEpub()` reads entire file into RAM. `_calculateFileHash()` reads entire file for MD5 (OOM risk). EPUB cover extracted via `image` pkg as JPEG. PDF gets no metadata extraction (title = filename). `downloadCover()` has no timeout or size limit. |
| `notification_service.dart` | 200 | 6/10 | ✅ Real | Channels: engagement / reminders / boosts. Weekend 2× boost notifications Saturday+Sunday 10 AM. Daily reminder at user-set time. Notification tap handler doesn't route anywhere (no deep link). |

**Critical DB issues:**
- Missing indices: `CREATE INDEX idx_bookmarks_bookId ON bookmarks(bookId)` (and highlights, sessions, dictionary_lookups).
- `SELECT *` on full tables at startup.
- Streak calculation iterates ALL sessions — O(n) with no limit.
- No `ON DELETE CASCADE` — manual cascade via `hardDeleteBook` transaction.

### 5.3 Providers — Score: 3/10

| File | LOC | Score | Notes |
|---|:---:|:---:|---|
| `library_provider.dart` | 1,538 | 3/10 | **God class.** 54 methods. `LibraryNotifier` handles: book CRUD, XP/level/streak calc, quest generation+update, achievement unlock, bookmark CRUD, dictionary lookup, filtering/sorting, goal management, notification scheduling, deferred notifications. `LibraryState` has 40+ fields. |
| `reader_settings_provider.dart` | 133 | 7/10 | Clean. 2-second debounced save to SharedPreferences. EPUB/PDF separate theme memory (epubTheme persistent; PDF theme transient). |

**`LibraryNotifier` recommended split:**
1. `LibraryNotifier` — Book CRUD, filtering, sorting, import
2. `GamificationNotifier` — XP, levels, streaks, achievements
3. `QuestNotifier` — Daily quest generation + progress
4. `AnnotationNotifier` — Highlights, bookmarks, vocabulary
5. `GoalNotifier` — Weekly goals, reading stats

### 5.4 Screens — Score: 4/10

| File | LOC | Score | Status | Notes |
|---|:---:|:---:|:---:|---|
| `reading_screen.dart` | 2,515 | 3/10 | ✅ Real | **God class.** EPUB init, PDF rendering, audio, search, bookmarks, highlights, orientation, battery, tutorial, heartbeat, progress sync, markdown export, dictionary lookup, navigation sheet. |
| `library_screen.dart` | 565 | 6/10 | ✅ Real | Multi-select, batch tag, delete, import. Works well. |
| `dashboard_screen.dart` | 358 | 6/10 | ✅ Real | Continue reading card, quick stats, heatmap, horizontal shelf. Flutter_animate on first load. |
| `stats_screen.dart` | 267 | 7/10 | ✅ Real | Level card, weekly goal, daily quests, heatmap with month picker, 18 achievement badges. |
| `settings_screen.dart` | 413 | 6/10 | ✅ Real | Notifications on/off + time picker, app theme toggle (Light/Dark/System), donation + GitHub links, package info. |
| `edit_book_screen.dart` | 348 | 6/10 | ✅ Real | Title/author/series/tags edit, audio track management, cover from file or Google image search. |
| `main_navigation.dart` | 353 | 6/10 | ✅ Real | Glass bottom nav, SharedAxisTransition, sharing intent, first-launch tutorial, rank-up dialog listener. |
| `google_image_search_screen.dart` | 162 | 5/10 | ✅ Real | WebView + JS injection intercept. Fragile (depends on Google DOM). |
| `file_selection_screen.dart` | 126 | 4/10 | ❌ Orphaned | Not reachable from main navigation. Dead code or future use. |

### 5.5 Reading Widgets — Score: 5/10

| File | LOC | Score | Status | Notes |
|---|:---:|:---:|:---:|---|
| `epub_chapter_page.dart` | ~1,046 | 5/10 | ✅ Real | CSS injection, highlight span injection (with occurrence-index position encoding), image resolution from EPUB content map, overscroll chapter navigation, auto-scroll via Ticker, `SelectionArea` with custom context menu (5 color buttons + note + copy + dictionary + share). |
| `navigation_sheet.dart` | ~1,597 | 4/10 | ✅ Real | 2 tabs: CHAPTERS (tree TOC + jump field) and ANNOTATIONS (bookmarks + highlights + vocabulary). Color filter bar. Selection mode + bulk delete. Export + share quote. Needs splitting into 4+ widgets. |
| `pdf_view.dart` | ~264 | 6/10 | ✅ Real | `PdfViewer.file` + ColorFilter matrix for themes. |
| `note_editor.dart` | ~302 | 6/10 | ✅ Real | `QuillEditor` + `QuillSimpleToolbar`. 5-color picker on same sheet. |
| `reading_header.dart` | ~235 | 7/10 | ✅ Real | Chapter title, live clock, battery level + icon, search toggle, lock toggle. |
| `reading_footer.dart` | ~155 | 7/10 | ✅ Real | Draggable progress slider with chapter/page display. |
| `reading_bottom_controls.dart` | ~348 | 6/10 | ✅ Real | Audio toggle, TOC, bookmark, auto-scroll, orientation, display settings. |
| `reading_audio_section.dart` | ~212 | 7/10 | ✅ Real | Position slider, play/pause, skip ±30s, track title, speed display. |
| `share_quote_sheet.dart` | ~620 | 6/10 | ✅ Real | Styled quote image preview + share. |
| `note_view.dart` | ~138 | 7/10 | ✅ Real | Renders stored Quill markdown notes. |
| `epub_view.dart` | ~107 | 7/10 | ✅ Wrapper | `PageView.builder` of `EpubChapterPage`. |
| `reading_search_overlay.dart` | ~78 | 7/10 | ✅ Real | Search bar + result list. |
| `play_pause_button.dart` | ~36 | 8/10 | ✅ Clean | Animated button. |
| `control_button.dart` | ~26 | 8/10 | ✅ Clean | Reusable icon button. |

### 5.6 Components — Score: 7/10
All 11 component files are real implementations:
- `activity_graph.dart` — GitHub-style 7-column monthly heatmap (5 levels). Tappable → daily breakdown.
- `book_card.dart` — Grid/list card with cover, progress bar, status chip, multi-select overlay.
- `daily_quests_card.dart` — 3 quests with progress bars, weekend 2× badge.
- `rank_up_dialog.dart` — Animated celebration with pulsing radial gradient.
- `rank_path_widget.dart` — 6-rank progression path visualization.
- `glass_container.dart` — BackdropFilter glassmorphism used throughout.
- `display_settings_sheet.dart` — Theme circles, typeface picker, text size, line height, alignment, publisher defaults, auto-scroll speed, lock state.

### 5.7 Core Design System — Score: 7/10
- 50+ component token categories in `TibebThemeExtension`.
- Feature placeholder token classes exist for: AI, Audiobook, Dictionary, Download, Highlight, Knowledge Graph, Library, Notes, PDF Viewer, Reader, Search, Statistics, Sync — **all empty, but correctly planned**.
- `TibebTheme.light()` and `TibebTheme.dark()` fully built.
- Brand colors `#d4af37` (gold) not yet mapped to a named token — needs explicit `goldPrimary` token.

### 5.8 Gamification Core — Score: 8/10

**Rank System (authentic Ge'ez titles):**
| Rank | Level | Achievements Required |
|---|:---:|:---:|
| Temari (ተማሪ) | 1 | 0 |
| Anebabi (አነባቢ) | 5 | 2 |
| Tsehafi (ፀሐፊ) | 10 | 5 |
| Liq (ሊቅ) | 20 | 8 |
| Baletibeb (ባለ ትብብ) | 40 | 10 |
| Tibebawi (ትቤቡ) | 50 | 12 |

**XP Multipliers (real logic in `_calculateStats`):**
- Base: 10 XP/page + 5 XP/minute
- 1.5× for sessions 6–9 AM (Early Bird)
- 1.5× for sessions 10 PM–1 AM (Night Owl)
- 2× for weekend sessions (Saturday/Sunday) — overrides time boosts
- Quest XP added from DB total

**18 Achievements (real, tracked):** First Page, Habit Builder, 7-Day Streak, Bookworm (1000p), Night Owl, Early Bird, Century Club (100p/session), Unstoppable (30-day streak), Marathoner (2h session), Scholar (5000p), Yomibito (10 books), Sensei (50 books), Bibliophile (10 in library), Collector (100 in library), Weekend Warrior, Word Seeker (1 lookup), Vocab Builder (20 lookups), Lexicoguru (100 lookups).

---

## 6. Technical Debt Register

### 🔴 Critical Priority

| Debt Item | Location | Impact | Estimated Effort |
|---|---|---|---|
| **God class: `_ReadingScreenState`** | `reading_screen.dart` (2,515 LOC, 59 methods) | Every new reader feature (sleep timer, audio sync, new format) requires editing this monolith. Merge conflicts guaranteed with >1 developer. Zero unit-test possibility. | 2 weeks (split into EpubController, PdfController, AudioController, SearchManager, BookmarkManager, ProgressTracker) |
| **God class: `LibraryNotifier`** | `library_provider.dart` (1,538 LOC, 54 methods) | XP/streak/quest/goal/bookmark/notification logic all in one class. Impossible to test in isolation. Every change risks breaking 6 unrelated features. | 1.5 weeks (split into 5 notifiers) |
| **No repository abstraction** | `database_service.dart`, `book_service.dart` | Direct SQLite coupling prevents swapping to cloud backend. Makes offline-first sync architecture impossible without full rewrite. | 1 week (build `BookRepository` abstract class + SQLite impl) |
| **Zero test coverage** | `test/widget_test.dart` (default counter test only) | No regression safety. Every change is a deployment risk. Onboarding new developers is risky. | 2 weeks (build initial suite for DB, models, XP calc, streak logic, quest generation) |

### 🟡 High Priority

| Debt Item | Location | Impact | Estimated Effort |
|---|---|---|---|
| **`navigation_sheet.dart` (1,597 LOC)** | `widgets/reading/` | A bottom sheet with 2 tabs (TOC + Annotations) + tree recursion + search + color filter + selection mode + export/share. Impossible to navigate. | 1 week (split into TOCSheet, AnnotationsSheet, BookmarksList, HighlightsList, VocabularyChips) |
| **`epub_chapter_page.dart` (1,046 LOC)** | `widgets/reading/` | CSS injection + HTML processing + highlight regex + image resolution + selection handling + context menu + auto-scroll + overscroll in one widget. | 1 week (split into EpubHtmlProcessor, HighlightInjector, ImageResolver, SelectionHandler) |
| **Hardcoded strings** | Throughout: achievement titles, quest descriptions, notification messages, rank names (partially Ge'ez-named) | Blocks localization to Amharic, Afaan Oromo, Tigrinya, Somali. | 3–5 days (extract to `.arb` files, add l10n codegen to pubspec) |
| **No database indices** | `database_service.dart` | `SELECT *` on growing tables = slow queries. At 1,000+ books, startup will take 5+ seconds. | 1 day (add indices on `bookId`, `date`, `createdAt`) |
| **`BookService` reads entire files into memory** | `book_service.dart:192` (MD5), `:96` (EPUB) | OOM crash on large files. A 200MB EPUB will crash. A 500MB PDF hash will crash. | 2–3 days (streaming hash with `md5.startChunkedConversion()`, chunked EPUB read) |
| **Audio tracks stored as JSON in books table** | `book_model.dart:audioTracks` JSON-serialized | Violates database normalization. Cannot query/filter by track. Makes multi-track management fragile. | 1 day (create `audio_tracks` table, migrate data, update model) |

### 🟢 Medium Priority

| Debt Item | Location | Impact | Estimated Effort |
|---|---|---|---|
| No `equals`/`hashCode` on models | All 7 model classes | State comparison fails silently in Riverpod. May cause missed rebuilds or unnecessary rebuilds. | 1 day (add `equatable` or manual `operator ==`) |
| `Bookmark` model lacks `copyWith()` | `bookmark_model.dart` | Inconsistent immutability pattern vs other models. | 30 min |
| `SearchResult.metadata` is `dynamic` | `search_result_model.dart:7` | Type-unsafe. Runtime errors if wrong type passed. | 30 min (make generic or sealed union) |
| Commented-out code | `pubspec.yaml:40-43` (old receive_sharing_intent) | Confusing to contributors. | 5 min (delete) |
| `FileSelectionScreen` unreachable | `screens/file_selection_screen.dart` | Dead code or future use unclear. | 5 min (delete or document intent) |
| `downloadCover()` no timeout/size limit | `book_service.dart:153-172` | Can hang or download 100MB image. | 30 min (add `http.Client` with timeout, Content-Length check) |
| `freezed`, `go_router`, `riverpod_generator` in deps but unused | `pubspec.yaml` | Dead weight. Confuses intent. | 1 day (either implement codegen or remove deps) |

---

## 7. Performance Analysis

| Issue | Location | Severity | Fix |
|---|---|:---:|---|
| **Entire EPUB file into RAM** | `book_service.dart:96` | 🔴 | Stream-based reading or size limit before load |
| **MD5 hash reads entire file** | `book_service.dart:192` | 🔴 | `md5.startChunkedConversion()` with file stream |
| **All books loaded at startup** | `database_service.dart:getBooks()` | 🟡 | `LIMIT 50 ORDER BY lastReadAt DESC`; lazy-load rest |
| **All sessions loaded for streak** | `database_service.dart:getReadingSessions()` | 🟡 | Query: `SELECT DISTINCT date FROM reading_sessions ORDER BY date DESC LIMIT 365` |
| **No DB indices** | `database_service.dart` | 🟡 | Add indices on `bookId`, `date`, `createdAt`, `isDeleted` |
| **Stats calc on full session set** | `library_provider.dart:_calculateStats()` | 🟡 | Move to background isolate; cache result |
| **`_applyFilters()` rebuilds full list** | `library_provider.dart:817-925` | 🟢 | Acceptable <500 books; needs optimization at scale |

### Startup Time Analysis (Current)

```
main() →
  WidgetsBinding.ensureInitialized()    ~2ms
  NotificationService().init()           ~50ms (permission check + channel setup)
  SharedPreferences.getInstance()        ~20ms
  ProviderScope → MaterialApp            ~5ms
  LibraryNotifier._init():
    _loadGoal() — SharedPreferences      ~5ms
    loadBooks():
      getBooks() — SELECT * books        ~50–500ms (scales with library size)
      getReadingSessions() — SELECT *    ~50–2000ms (scales with sessions count)
      _calculateStats() — iterates all   ~20–500ms
      _loadQuests()                      ~10ms
    notification scheduling              ~30ms
```

**Risk:** With 500 books and 1 year of daily sessions (~365 rows), startup stats calculation could take 1–3 seconds, freezing the UI before the first frame.

---

## 8. Security Audit

| Area | Status | Severity | Finding |
|---|:---:|:---:|---|
| **Local database** | 🔴 Insecure | Critical | SQLite is completely unencrypted. Any app with root access can read all highlights, notes, and reading progress. Users with private books or sensitive annotations are exposed. |
| **Cover download** | 🟡 Risky | High | `downloadCover()` in `book_service.dart` downloads from arbitrary URLs with no TLS pinning, no size limit, no timeout. Potential for SSRF or large-download attacks. |
| **File access** | 🟢 Good | Low | Uses `FilePicker` (SAF-based). No legacy `MANAGE_EXTERNAL_STORAGE` permission. |
| **Authentication** | 🔴 Missing | Critical | No user identity system. Required for any cloud feature or data backup. |
| **Secure storage** | 🔴 Missing | Critical | No `flutter_secure_storage`. All preferences in plain SharedPreferences XML. |
| **Network security** | 🟡 Missing | Medium | No certificate pinning. No `SecurityContext` configuration. `http` package used without client-level timeout. |
| **Input validation** | 🟡 Partial | Medium | `Book.fromMap()` does null-coalescing. `sqflite` parameterized queries prevent SQL injection at query layer. |

### Recommendations
1. Migrate to `sqflite_sqlcipher` for at-rest encryption (~3–5 days).
2. Add `flutter_secure_storage` for any future tokens/keys.
3. Add request timeout to all `http.get()` calls: `http.get(url).timeout(Duration(seconds: 15))`.
4. Add file size validation in `processFile()` before loading into RAM.
5. When implementing auth: use OAuth2 PKCE flow, store tokens in `flutter_secure_storage` never in SharedPreferences.

---

## 9. UX Review

### Compared Against: Kindle · Readwise Reader · Kobo · Moon+ Reader · Audible

| Area | Tibeb | Kindle | Gap |
|---|---|---|---|
| Library grid | 2-column grid, cover + progress | Adaptive grid + list toggle | Acceptable. Missing list view. |
| Reading themes | 4 themes, instant switch | 4 themes + custom | On par |
| Font selection | 4 fonts (no Ethiopic) | 10+ including accessibility fonts | **Critical gap** — no Amharic/Ethiopic font |
| Font weight/margin/spacing | Not available | Full controls | Below Kindle standard |
| Highlight colors | 5 colors | 4 colors | Exceeds Kindle |
| Notes editor | Rich text (Quill) | Plain text | **Exceeds Kindle** — strong differentiator |
| Audio integration | Inline in reader with sync controls | Separate Audible app | **Innovative** — combined UX is novel |
| Knowledge review | None (vocab list only) | Readwise core feature | **Critical gap** for positioning |
| Gamification | XP, ranks, streaks, quests, achievements | None | **Exceeds all competitors** |
| Quote sharing | Styled image with book credit | Basic text share | **Exceeds Kindle** |
| Onboarding | Tutorial coach marks (4–6 targets) | Contextual tips | Acceptable |
| Error handling | None visible | Graceful recovery | Gap — corrupt file = silent crash |

### UX Anti-Patterns Found

1. **No loading feedback during import:** Importing a large EPUB shows no progress. User doesn't know if it worked.
2. **No undo for delete:** Soft delete exists but no "Undo" toast appears after deletion.
3. **No library search:** Global text search only exists inside the reader, not from the library grid screen.
4. **Navigation sheet too dense:** TOC + Bookmarks + Highlights + Vocabulary + Export in one 70% height bottom sheet — overwhelming.
5. **Audio controls in reading UI:** Audio section expansion inside the reader bottom controls is non-obvious for new users.

---

## 10. Accessibility Audit

| Area | Status | Notes |
|---|:---:|---|
| Screen reader (Semantics) | 🟡 Partial | No manual `Semantics` wrappers. Relies on Material widget defaults only. |
| Dynamic font scaling | 🟡 Partial | Reader has its own font size control. System-level font scaling may conflict. |
| Color contrast | ✅ Good | Dark themes have good contrast ratios (white text on dark backgrounds). |
| Touch target sizes | 🟡 Partial | Some icon buttons (e.g. in highlight context menu: 36×36dp) may be below 48×48dp WCAG minimum. |
| Keyboard navigation | ❌ Missing | No `FocusNode` management for keyboard/D-pad navigation. |
| RTL layout | ❌ Missing | Only `en_US` locale. No `Directionality.of(context)` usage. |
| App localization | ❌ Missing | All strings hardcoded in English. No `.arb` files. No `AppLocalizations` setup. |
| Reading accessibility | 🟡 Partial | Line height and font size are user-controlled. No dyslexia font (OpenDyslexic). |

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
- Unit: `DatabaseService` CRUD (insert, get, update, delete, hardDelete cascade)
- Unit: `_calculateStreak()` — edge cases (no sessions, streak broken, yesterday-only)
- Unit: `_calculateStats()` — XP multipliers, level calculation, achievement thresholds
- Unit: `_generateDailyQuests()` — weekday vs weekend multiplier
- Unit: `BookService.processFile()` with mock EPUB/PDF bytes

**Phase 2 — State (Week 2):**
- `LibraryNotifier` state transitions (import → loadBooks → filtered state)
- `ReaderSettingsProvider` persistence round-trip
- Quest completion + XP update flow

**Phase 3 — Widget Tests (Week 3):**
- `BookCard` with various book states (unread, reading, finished, favorite)
- `AchievementsGrid` with mocked unlocked set
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
| **Error boundaries** | Corrupt EPUB/PDF currently crashes app silently. Users will uninstall. | 3–5 days |
| **Bundled Amharic font (Abyssinica SIL)** | Without it, the Ethiopian differentiator is literally invisible. Add to `assets/fonts/`, register in pubspec, add to typeface picker. | 1 day |
| **Highlight cross-book review screen** | The #1 "Readwise" differentiator is a screen where you review all highlights from all books. Currently only per-book export exists. | 3–5 days |
| **Sleep timer for audio** | Every audiobook user expects this. Simple `Timer` + `AudioPlayer.pause()`. | 1–2 days |
| **Font weight + margin + spacing controls** | Needed to reach Kindle parity. Add fields to `ReaderSettings`, sliders to `DisplaySettingsSheet`. | 1–2 days |
| **Encrypted local database** | Annotations are private. Use `sqflite_sqlcipher`. | 3–5 days |
| **Full data backup/restore** | Users fear data loss. JSON export/import of all annotations + reading progress. Encrypted. | 3–5 days |

### 🟡 Should Have (v1.1 — 6 weeks post-launch)

| Gap | Why Important | Effort |
|---|---|---|
| **Cloud sync** | Multi-device users and the #1 user anxiety ("what if I lose my phone?"). Build on Supabase/Firebase with offline-first conflict resolution. | 3+ weeks |
| **Spaced repetition flashcards** | Converts highlights into SM-2 algorithm review cards. The "Anki inside your reader" differentiator. | 1–2 weeks |
| **Tag highlights** | Add `tags` field to `Highlight` model, DB migration v19, tag input in note editor, filter by tag in highlights browser. | 3–5 days |
| **App localization (Amharic first)** | Extract all strings to `.arb` files. Add `am` locale to `supportedLocales`. The single biggest trust signal for Ethiopian users. | 1–2 weeks |
| **CBZ/CBR comic support** | Extends the "all formats" promise. Add `archive` package usage for zip-based comics. | 3–5 days |
| **Auto sunrise/sunset theme** | Time-based reader theme switching. Add `sunrise_sunset` calculation to `ReaderSettingsNotifier`. | 1–2 days |
| **Hyphenation** | Add `hyphens: auto; -webkit-hyphens: auto;` to CSS injection in `epub_chapter_page.dart`. 30-minute fix, major typography quality improvement. | 30 min |
| **Cross-book full-text search** | "Show everything about leadership." Requires background indexing of all book content. | 3–5 days |

### 🟢 Later (v2.0+ — The Vision)

| Gap | Why It Makes Tibeb Unique | Effort |
|---|---|---|
| **Knowledge Graph** | Books → People → Concepts → Quotes → Ideas linked across your entire library. The "Obsidian for readers." | 3+ weeks |
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
| Reading engine (EPUB) | 🟡 | Crashes on corrupt files | Add `ErrorWidget.builder`, try-catch on parse |
| Reading engine (PDF) | 🟡 | Same as above | Add error boundaries |
| Audio playback | 🟡 | No sleep timer | Implement timer (1-2 days) |
| Storage (SQLite) | ❌ | Unencrypted, no indices | Migrate to sqlcipher, add indices (5 days) |
| Annotation system | 🟡 | No tags, no cross-book view | Add tags field + review screen (5 days) |
| Gamification | ✅ | — | **Production ready** |
| Sync | ❌ | Not implemented | **Blocks multi-device users** (3+ weeks) |
| Offline support | 🟡 | Works but no backup | Add encrypted export/import (3-5 days) |
| Auth | ❌ | Not implemented | **Required for sync** (1 week) |
| Performance | 🟡 | OOM risk on large files | Streaming hash, chunked EPUB read (3 days) |
| Security | ❌ | Plain-text DB, no secrets | Encrypt + secure storage (5 days) |
| Error handling | ❌ | No global boundaries | `ErrorWidget.builder` + Sentry (3 days) |
| Monitoring / Analytics | ❌ | No visibility | Firebase Analytics / Mixpanel (2 days) |
| Logging | ❌ | `debugPrint()` only | Structured logging with `logger` (1 day) |
| Testing | ❌ | 0% coverage | Min 60% before launch (2 weeks) |
| CI/CD | ❌ | No pipeline | GitHub Actions: lint → test → build (1 day) |
| Accessibility | ❌ | No Semantics, no l10n | Add Semantics + `.arb` files (1 week) |
| Deep linking | ❌ | No router | Add `go_router` deep link support (3 days) |

---

## 14. Prioritized Roadmap

### Phase 1 — Stabilization (Weeks 1–2)

**Goal:** Make the app safe to ship without data loss or crashes.

- [ ] **Add error boundaries** — `ErrorWidget.builder` globally. Try-catch wrappers on EPUB/PDF parsing with user-facing error screens ("This file is corrupted. Try re-downloading.").
- [ ] **Fix OOM risks** — Use `md5.startChunkedConversion()` for file hashing. Add max file size limit before loading EPUBs into RAM (e.g., 50MB soft limit).
- [ ] **Add database indices** — `CREATE INDEX idx_bookmarks_bookId ON bookmarks(bookId)`. Same for `highlights`, `reading_sessions`, `dictionary_lookups`.
- [ ] **Set up CI/CD** — GitHub Actions workflow: `flutter analyze`, `flutter test` (even if minimal), `flutter build apk --release`.
- [ ] **Start refactoring god files** — Extract `EpubController`, `PdfController`, `AudioController` from `reading_screen.dart`. Extract `GamificationNotifier` from `library_provider.dart`.

**Success Metrics:** Zero crashes on corrupt files. Startup time <1s for libraries <100 books. CI pipeline passes on every PR.

---

### Phase 2 — MVP Completion (Weeks 3–6)

**Goal:** Ship v1.0 with differentiated features ready for public launch.

- [ ] **Bundle Abyssinica SIL font** — Add to `assets/fonts/`, register in `pubspec.yaml`, add to typeface picker in `ReaderSettings.availableTypefaces`.
- [ ] **Highlight cross-book browser** — New screen: `AllHighlightsScreen`. List all highlights across all books with search, filter by color/book, export all as Markdown.
- [ ] **Sleep timer** — Add `Timer` to `_ReadingScreenState`, time picker in audio controls, auto-pause on timer expiry.
- [ ] **Tag highlights** — Add `tags` field to `Highlight` model. DB migration v19: `ALTER TABLE highlights ADD COLUMN tags TEXT`. Tag input in `NoteEditor`.
- [ ] **Font weight + margin + spacing controls** — Add fields to `ReaderSettings`. Sliders in `DisplaySettingsSheet`. Inject into CSS.
- [ ] **Hyphenation** — Inject `hyphens: auto; -webkit-hyphens: auto;` into `<body>` style in `epub_chapter_page.dart`. Test on English + Amharic.
- [ ] **Encrypted local backup** — JSON export/import of `books`, `highlights`, `bookmarks`, `reading_sessions`, `quests`, `dictionary_lookups`. AES encryption with user passphrase.
- [ ] **Encrypt SQLite** — Migrate from `sqflite` to `sqflite_sqlcipher`. Generate encryption key, store in `flutter_secure_storage`.
- [ ] **Basic test suite** — 40% coverage target: DB CRUD tests, `_calculateStreak()`, `_calculateStats()`, `_generateDailyQuests()`.
- [ ] **First localization** — Amharic `.arb` file with all hardcoded strings extracted. Add `am` to `supportedLocales`.

**Success Metrics:** App is shippable to Ethiopian users. Highlights can be reviewed across all books. Data backup/restore works. Core logic is tested.

---

### Phase 3 — Differentiation (Weeks 7–14)

**Goal:** Build the features that make Tibeb unique vs Kindle/Kobo.

- [ ] **Cloud sync** — Supabase backend with offline-first `sync_queue` table. Conflict resolution: last-write-wins with timestamp per entity.
- [ ] **Spaced repetition flashcards** — `Flashcard` model. `FlashcardNotifier`. SM-2 algorithm for review scheduling. Generate flashcards from highlights with "Convert to flashcard" button.
- [ ] **Cross-book search** — Background isolate to index all book content. `SearchService` with SQLite FTS5 table. "Search my library" screen.
- [ ] **Auto sunrise/sunset theme** — Add `sunrise_sunset` package. Calculate local sunrise/sunset times. Auto-switch reader theme at those times.
- [ ] **CBZ/CBR support** — Add `ComicReaderScreen`. Use `archive` package to extract images from zip/rar. Page-flip UI with image rendering.
- [ ] **App localization expansion** — Add Afaan Oromo, Tigrinya, Somali localizations with native speaker review.
- [ ] **Router migration** — Replace all `Navigator.push()` with `go_router`. Add deep links for: `/book/:id`, `/highlights`, `/stats`, `/reading/:bookId`.
- [ ] **Analytics integration** — Firebase Analytics / Mixpanel. Track: books imported, highlights created, audio usage, quest completion, level ups.

**Success Metrics:** Cloud sync works without data loss. Users can create flashcards from highlights. Cross-book search finds conceptual links. Localization ships with at least 2 languages beyond English.

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

**Success Metrics:** Users report "I never need another reading app." Knowledge graph generates useful cross-book insights. Audio-text sync feels like magic. Ethiopian authors have a distribution channel.

---

## Final Verdict

### What's Remarkable
Tibeb has **real, working implementations** of difficult features:
- EPUB rendering with CSS injection, highlight injection, image resolution, and auto-scroll.
- PDF rendering with theme-aware ColorFilter and full-text search.
- Multi-track audiobook with position persistence.
- Gamification with authentic Ge'ez cultural integration and time-of-day XP multipliers.
- A token-based design system with 50+ component categories.

These are not placeholders — they work.

### What's Blocking Launch
- **God files** block scaling the team or features.
- **No sync** means users fear data loss.
- **Zero tests** mean every change is risky.
- **No Amharic font bundled** despite Ethiopian positioning.
- **Plain-text SQLite** is a privacy risk.

### Strategic Recommendation
**6-week intensive refactor:**
- Weeks 1–2: Stabilize (error boundaries, indices, OOM fixes, CI).
- Weeks 3–6: Complete MVP (Amharic font, highlight browser, sleep timer, encryption, basic tests, localization).

After these 6 weeks, you have a **shippable v1.0** that delivers on the core promise:
> "Kindle + Readwise + Audible for Ethiopian readers with gamification that makes reading addictive."

Then launch publicly. Collect user feedback. Build Phase 3 (sync + flashcards + cross-book search) based on real usage data.

The knowledge graph and AI features (Phase 4) are 6+ months out — don't block launch on them.

---

**End of Audit** — Generated 2026-07-03 by Kiro AI Assistant
