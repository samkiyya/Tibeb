# 🔍 Tibeb — Codebase Audit & Implementation Tracker

> **Audited:** 2026-07-02 | **Flutter SDK:** ^3.10.7 | **Target:** Kindle + Readwise + Obsidian + Audible for Ethiopian & global readers

---

## Table of Contents

- [1. Architecture Overview](#1-architecture-overview)
- [2. Feature Status Matrix](#2-feature-status-matrix)
- [3. Implementation Checklist](#3-implementation-checklist)
- [4. Database Schema Gaps](#4-database-schema-gaps)
- [5. Code Quality Issues](#5-code-quality-issues)
- [6. Dependency Audit](#6-dependency-audit)
- [7. Test Coverage](#7-test-coverage)
- [8. Build & Configuration Notes](#8-build--configuration-notes)

---

## 1. Architecture Overview

```
lib/
├── main.dart                              # Entry point, ProviderScope, TibebTheme
├── core/
│   ├── constants.dart                     # Colors, shadows, ranks, highlight palette
│   ├── tibeb_rank.dart                    # Rank model
│   ├── tibeb_rank_data.dart               # Static rank definitions (Ge'ez names)
│   ├── tibeb_rank_repository.dart         # Rank lookup by level + achievements
│   ├── tibeb_rank_extension.dart          # Display helpers
│   ├── tibeb_rank_strings.dart            # Localized strings
│   └── theme/                             # Material design tokens & component themes
│       ├── tibeb_theme.dart               # Theme factory (light/dark)
│       ├── tokens/ (colors, typography, spacing, radius)
│       ├── semantics/ (color_scheme, theme_extension)
│       └── components/ (app_bar, button, card, nav_bar, progress)
├── models/
│   ├── book_model.dart                    # Book + AudioTrack (217 lines)
│   ├── bookmark_model.dart                # Bookmark with CFI/offset position
│   ├── highlight_model.dart               # Highlight with color, note, chapter
│   ├── quest_model.dart                   # DailyQuest with QuestType enum
│   ├── reader_settings_model.dart         # Theme, typeface, size, alignment
│   ├── search_result_model.dart           # Search result with snippet
│   └── vocabulary_model.dart              # Dictionary lookup record
├── services/
│   ├── database_service.dart              # SQLite v18, all CRUD operations
│   ├── book_service.dart                  # EPUB/PDF import, cover extraction, MD5 dedup
│   └── notification_service.dart          # Local push, daily reminders, 2x weekend
├── providers/
│   ├── library_provider.dart              # Main state: books, XP, levels, quests (1538 lines)
│   └── reader_settings_provider.dart      # Reader display prefs via SharedPreferences
├── screens/
│   ├── main_navigation.dart               # Bottom nav, sharing intent, rank celebrations
│   ├── dashboard_screen.dart              # Continue reading, quick stats, activity graph
│   ├── library_screen.dart                # Grid library, multi-select, filter/sort
│   ├── reading_screen.dart                # EPUB/PDF engine, audio, search (2515 lines)
│   ├── stats_screen.dart                  # Level, goals, quests, achievements
│   ├── settings_screen.dart               # Notifications, donate, GitHub
│   ├── edit_book_screen.dart              # Edit metadata
│   ├── reading/widgets/                   # epub_view, pdf_view, epub_chapter_page, etc.
│   ├── dashboard/widgets/                 # header, continue_reading_card, shelf_item
│   └── library/widgets/                   # empty_library_view, library_header, add_book_fab
├── components/                            # Reusable UI widgets
│   ├── activity_graph.dart                # GitHub-style heatmap
│   ├── book_card.dart                     # Library grid card
│   ├── glass_container.dart               # Glassmorphism container
│   ├── display_settings_sheet.dart        # Theme/font/size controls
│   ├── streak_widget.dart                 # Fire animation
│   ├── rank_up_dialog.dart                # Celebration popup
│   └── ... (stat_badge, daily_quests_card, rank_path_widget, etc.)
└── utils/
    └── tutorial_helper.dart               # First-launch coach marks
```

**State Management:** `flutter_riverpod` with `StateNotifierProvider`  
**Database:** `sqflite` v18 with incremental migrations  
**Reading Engines:** `epubx` + `flutter_html` (EPUB) | `pdfrx` (PDF)  
**Audio:** `just_audio` with `ConcatenatingAudioSource` playlists

---

## 2. Feature Status Matrix

> ✅ Done | ⚠️ Partial | ❌ Not Done

### A. Format Support

| Feature | Status | Notes |
|---|:---:|---|
| EPUB | ✅ | `epubx` parser + `flutter_html` chapter renderer |
| PDF | ✅ | `pdfrx` with theme-aware `ColorFilter` |
| CBZ/CBR | ❌ | No comic parser |
| MOBI/AZW3 | ❌ | No Kindle format support |
| Markdown viewer | ❌ | `markdown` package in deps but unused for reading |
| HTML articles | ❌ | No article capture pipeline |

### B. Reading Experience

| Feature | Status | Notes |
|---|:---:|---|
| Fast page turns | ✅ | Vertical `PageView.builder` |
| Custom fonts | ⚠️ | 4 typefaces (Merriweather, Georgia, Lexend, System); **no offline Amharic fonts** |
| Font weight control | ❌ | No slider exposed |
| Letter/word spacing | ❌ | Not implemented |
| Margin control | ❌ | Hardcoded 20px |
| Line-height | ✅ | Slider 1.0–2.5 |
| Hyphenation | ❌ | Not implemented |
| Vertical scrolling | ✅ | Default EPUB mode |
| RTL support | ❌ | Only `en_US` locale |
| Amharic rendering | ⚠️ | System font only |

### C. Themes

| Feature | Status | Notes |
|---|:---:|---|
| Light (white) | ✅ | `#FFFFFF` |
| Dark | ✅ | `#1A2744` |
| Sepia | ✅ | `#F5F0E1` |
| AMOLED black | ✅ | `#0A0B0E` |
| Auto sunrise/sunset | ❌ | No time-based switching |

### D. Navigation

| Feature | Status | Notes |
|---|:---:|---|
| Table of contents | ✅ | `NavigationSheet` |
| Full-text search (EPUB) | ✅ | Regex across all chapters |
| Full-text search (PDF) | ✅ | `PdfTextSearcher` |
| Progress bar | ✅ | Scroll-based in footer |
| Jump to position | ✅ | Slider-based |

### E. Annotations

| Feature | Status | Notes |
|---|:---:|---|
| Highlights (5 colors) | ✅ | Red, Yellow, Green, Blue, Purple |
| Notes | ✅ | Rich text via `flutter_quill` |
| Bookmarks | ✅ | Chapter-level with position restore |
| Tag highlights | ❌ | No `tags` field in model |
| Export highlights | ❌ | No JSON/Markdown/CSV export |
| Highlight review screen | ❌ | No cross-book highlights browser |
| Underline mode | ❌ | Only highlight background |

### F. Audiobook

| Feature | Status | Notes |
|---|:---:|---|
| MP3/M4B playback | ✅ | `just_audio` + `FilePicker` |
| Variable speed | ✅ | `AudioPlayer.setSpeed()` |
| Multi-track navigation | ✅ | `ConcatenatingAudioSource` |
| Position resume | ✅ | Auto-save every 10s |
| Sleep timer | ❌ | Not implemented |
| Audio-text sync | ❌ | No Whispersync mapping |

### G. Knowledge System

| Feature | Status | Notes |
|---|:---:|---|
| Knowledge Graph | ❌ | Zero implementation |
| Second Brain queries | ❌ | No cross-book search |
| Spaced Repetition | ❌ | No flashcard system |

### H. Sync & Reliability

| Feature | Status | Notes |
|---|:---:|---|
| Offline-first | ✅ | SQLite local DB |
| Cloud sync | ❌ | No sync service |
| Encrypted backup | ❌ | Plain-text SQLite |
| Data export | ❌ | No export functionality |

### I. Gamification

| Feature | Status | Notes |
|---|:---:|---|
| Streaks | ✅ | Calculated from sessions |
| Reading goals | ✅ | Pages/minutes/XP weekly |
| Achievements (15) | ✅ | Badges for milestones |
| Daily quests (3) | ✅ | With 2x weekend multiplier |
| XP system | ✅ | 10/page + 5/min × multiplier |
| Rank system (6 Ge'ez) | ✅ | Temari → Tibebawi |

### J. AI Features

| Feature | Status |
|---|:---:|
| Passage explainer | ❌ |
| Chapter summarizer | ❌ |
| Flashcard generator | ❌ |
| Smart search | ❌ |

### K. Ethiopian Advantage

| Feature | Status | Notes |
|---|:---:|---|
| Bundled Amharic fonts | ❌ | No Ethiopic fonts in assets |
| Amharic OCR | ❌ | No OCR |
| Amharic TTS | ❌ | No TTS |
| App localization (am/om/ti/so) | ❌ | English only |

### L. Universal Capture

| Feature | Status | Notes |
|---|:---:|---|
| Receive shared files | ✅ | `receive_sharing_intent` wired in `main_navigation.dart` |
| Web clipper | ❌ | No web article capture |

---

## 3. Implementation Checklist

### Phase 1: MVP Completion 🔴 (Must-Have)

- [ ] **Bundle Amharic fonts** — Package Abyssinica SIL in `assets/fonts/`, add to typeface selector *(~1-2 days)*
- [ ] **Export highlights** — Markdown/JSON export from a highlights review screen *(~3-5 days)*
- [ ] **Sleep timer** — Timer with auto-pause for audio playback *(~1-2 days)*
- [ ] **Tag highlights** — Add `tags` to `Highlight` model + DB migration v19 *(~3-5 days)*
- [ ] **Highlight review screen** — Browse all highlights across all books *(~3-5 days)*
- [ ] **Encrypted local backup** — JSON export/import of all annotations + books *(~3-5 days)*
- [ ] **Font weight + margin + spacing controls** — Add sliders to display settings sheet *(~1-2 days)*
- [ ] **Hyphenation** — CSS `hyphens: auto` injection for EPUB renderer *(~1 day)*

### Phase 2: Readwise Layer 🟡 (Should-Have)

- [ ] **Spaced repetition flashcards** — SM-2 review system from highlights *(~1-2 weeks)*
- [ ] **Cross-book highlight search** — "What did I learn about X?" *(~3-5 days)*
- [ ] **Auto sunrise/sunset theme** — Time-based reader theme switching *(~1-2 days)*
- [ ] **App localization** — Amharic, Afaan Oromo, Tigrinya, Somali *(~1-2 weeks)*
- [ ] **CBZ/CBR support** — Zip/image comic reader *(~3-5 days)*
- [ ] **MOBI import** — Via conversion library *(~3-5 days)*

### Phase 3: Banking-Grade Sync 🔵 (Cloud)

- [ ] **Migrate to `sqflite_sqlcipher`** — At-rest encryption *(~3-5 days)*
- [ ] **Cloud sync service** — Supabase/Firebase with conflict resolution *(~3+ weeks)*
- [ ] **Universal capture pipeline** — Web articles, tweets, papers *(~1-2 weeks)*

### Phase 4: Obsidian Layer 🟣 (Intelligence)

- [ ] **Knowledge Graph** — Concepts, people, ideas linked across books *(~3+ weeks)*
- [ ] **AI passage explainer** — Gemini API chapter summaries *(~3-5 days)*
- [ ] **Amharic TTS** — On-device text-to-speech *(~1-2 weeks)*
- [ ] **Amharic OCR** — Camera-based book scanning *(~1-2 weeks)*

### Phase 5: Scale ⚪ (Later)

- [ ] Social features (reading circles, sharing) *(~3+ weeks)*
- [ ] Plugin/extension system *(~3+ weeks)*
- [ ] Public API *(~1-2 weeks)*
- [ ] Marketplace for Ethiopian books *(~3+ weeks)*

---

## 4. Database Schema Gaps

**Current version:** 18

### Required new tables (migration v19+):

```sql
-- Spaced Repetition
CREATE TABLE flashcards (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    highlightId INTEGER REFERENCES highlights(id),
    front TEXT,
    back TEXT,
    nextReviewDate TEXT,
    interval INTEGER DEFAULT 1,
    easeFactor REAL DEFAULT 2.5,
    repetitions INTEGER DEFAULT 0,
    createdAt TEXT
);

-- Knowledge Graph
CREATE TABLE concepts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    type TEXT,  -- 'person', 'idea', 'quote', 'topic'
    createdAt TEXT
);

CREATE TABLE concept_links (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sourceId INTEGER,
    sourceType TEXT,  -- 'book', 'highlight', 'concept'
    targetId INTEGER,
    targetType TEXT,
    relation TEXT,  -- 'mentions', 'inspired_by', 'related_to'
    createdAt TEXT
);

-- Highlight Tags
CREATE TABLE highlight_tags (
    highlightId INTEGER REFERENCES highlights(id),
    tag TEXT,
    PRIMARY KEY (highlightId, tag)
);

-- Universal Capture
CREATE TABLE captured_articles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    url TEXT,
    title TEXT,
    htmlContent TEXT,
    markdownContent TEXT,
    sourceType TEXT,  -- 'web', 'email', 'twitter', 'paper'
    addedAt TEXT,
    tags TEXT
);

-- Sync Metadata (add to all entity tables)
ALTER TABLE books ADD COLUMN uuid TEXT;
ALTER TABLE books ADD COLUMN syncStatus TEXT DEFAULT 'pending';
ALTER TABLE books ADD COLUMN lastSyncedAt TEXT;
-- (repeat for highlights, bookmarks, flashcards, etc.)
```

---

## 5. Code Quality Issues

| Issue | Severity | Location | Fix |
|---|:---:|---|---|
| **God file** | 🟡 | `reading_screen.dart` (2515 lines) | Extract audio controller, progress tracker, search into services |
| **God provider** | 🟡 | `library_provider.dart` (1538 lines) | Split into `GamificationNotifier`, `LibraryNotifier`, `SyncNotifier` |
| **No DI for services** | 🟡 | `DatabaseService()` singleton | Use Riverpod providers for testability |
| **No error boundaries** | 🟡 | EPUB parsing | Add try-catch + user-facing error screens |
| **Hardcoded strings** | 🟡 | Achievements, quests | Move to locale-aware `.arb` files |
| **No CI/CD** | ℹ️ | No workflows | Add GitHub Actions for analyze + test |

---

## 6. Dependency Audit

| Package | Version | Purpose | Status |
|---|---|---|:---:|
| `flutter_riverpod` | ^3.3.2 | State management | ✅ |
| `epubx` | ^4.0.0 | EPUB parsing | ✅ |
| `pdfrx` | ^2.4.4 | PDF rendering | ✅ |
| `just_audio` | ^0.10.6 | Audio playback | ✅ |
| `sqflite` | ^2.3.0 | Local database | ✅ |
| `flutter_html` | ^3.0.0-beta.2 | HTML rendering | ⚠️ Beta |
| `flutter_quill` | ^11.5.0 | Rich notes | ✅ |
| `receive_sharing_intent` | ^1.9.0 | OS file sharing | ✅ |
| `image` | ^4.3.0 | Image processing | ⚠️ Override |
| `google_fonts` | ^8.1.0 | Typography | ✅ |

> **Note:** `image` uses `dependency_overrides` to force v4.x (needed by `pdfrx_engine`) while `epubx` pins v3.x. Monitor for runtime issues.

---

## 7. Test Coverage

> ⚠️ **Only 1 test file exists:** `test/widget_test.dart` (default Flutter counter test). **Zero meaningful tests.**

### Required:
- [ ] Unit tests for `DatabaseService` CRUD
- [ ] Unit tests for XP/level/streak calculations
- [ ] Widget tests for `BookCard`, `DisplaySettingsSheet`
- [ ] Integration tests for read → highlight → bookmark flow

---

## 8. Build & Configuration Notes

### Fixed Issues (2026-07-02):

1. **`pdfrx_engine` build error** — `image` v3.x was incompatible with `pdfrx_engine 0.4.3` which uses v4.x APIs (`ChannelOrder`, `Image.fromBytes`). **Fix:** Added `dependency_overrides: image: ^4.3.0` to `pubspec.yaml`.

2. **Kotlin Gradle Plugin warning** — Removed `id("kotlin-android")` from `android/app/build.gradle.kts` and `org.jetbrains.kotlin.android` from `android/settings.gradle.kts`. Also removed `kotlinOptions` block. Flutter now uses built-in Kotlin.

### Plugin KGP Warnings (External):
The following plugins still apply KGP internally: `device_info_plus`, `file_picker`, `package_info_plus`, `quill_native_bridge_android`, `share_plus`. These will be fixed by plugin authors in future versions. Monitor their changelogs.
