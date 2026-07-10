<div align="center">

# 📖 Tibeb

### Where Reading Becomes Wisdom

*An open-source reading companion for EPUB, PDF, and audiobooks —*
*built to help you read, listen, learn, and grow.*

[![Flutter](https://img.shields.io/badge/Flutter-3.10.7-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.7-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[Overview](#-overview) •
[Features](#-features) •
[Architecture](#-architecture) •
[Tech Stack](#-tech-stack) •
[Getting Started](#-getting-started) •
[Contributing](#-contributing) •
[Roadmap](#-roadmap)

</div>

---

## ✨ Overview

**Tibeb** (ጥበብ — "Wisdom" in Ge'ez/Amharic) is more than an eBook reader.

It is a complete reading ecosystem designed to transform books into lasting knowledge. Whether you are reading an EPUB, studying a PDF, or listening to an audiobook, Tibeb keeps your entire reading journey in one place — from your library and reading progress to highlights, notes, achievements, and personal growth milestones.

> **Transform every page you read into lasting wisdom.**

Tibeb combines the reading experience of Kindle, the knowledge capture of Readwise, the depth of Obsidian, and the convenience of Audible — enriched with authentic Ethiopian cultural roots through the Ge'ez wisdom tradition.


---

## 🚀 Features

### 📚 Multi-Format Reading

| Format | Status | Notes |
|--------|:------:|-------|
| EPUB | ✅ | CSS injection, chapter navigation, internal links, image rendering |
| PDF | ✅ | Theme-aware ColorFilter, full-text search, outline navigation, page jump |
| Markdown / TXT | ✅ | Dual-mode (Preview/Edit), Mermaid diagram zoom, IntersectionObserver active heading sync, save/editing |
| Audiobook (MP3) | ✅ | Multi-track, variable speed, position resume, skip ±30s |
| CBZ / CBR | 🗓 Planned | Comic reader — v1.1 |
| MOBI / AZW3 | 🗓 Planned | Kindle format conversion pipeline |

### 📝 Plain Text & Markdown Reader

A professional-grade, interactive reader and editor for Markdown (`.md`) and TXT (`.txt`) documents, designed with complete decoupling:
- **Full Architecture Isolation** — The TXT and Markdown editors are completely isolated. Selection highlights, cursor colors, and backgrounds dynamically adapt to White, Sepia/Cream, Dark Blue, and Black themes without cross-editor overlap.
- **Custom offline Markdown compiler** — High-performance GFM rendering directly in Dart (supporting strikethrough, autolinks, custom tables, task lists, and footnotes) with local caching.
- **Offline KaTeX Math parser** — Real-time rendering of inline and block LaTeX mathematical equations without remote HTTP requests.
- **GitHub Alert Admonitions** — Support for styled alerts: note, tip, warning, important, and caution blocks.
- **Dual-mode preview and source editing** — Real-time hot swapping between visual preview and multiline plain-text edit zones with an interactive formatting toolbar.
- **Bi-directional scroll synchronization** — Scroll-percentage mapping keeps preview and edit scrolls in perfect alignment.
- **Hierarchical Table of Contents (TOC)** — In-sidebar tree TOC navigation with smooth JS-based `scrollIntoView` jumps.
- **Active heading tracking** — Local WebView `IntersectionObserver` keeps progress footer synchronized as you read.
- **In-document Search & Navigation** — Integrated search engine highlighting regex and literal string matches.
- **Offline Mermaid rendering** — Fully renders Mermaid diagrams with tap-to-zoom gestures and pinch/pan interactive modal overlays.
- **Direct file saving & copy-actions** — In-header save operations write changes back to local storage offline.

---

### 🎨 Reader Experience

Four hand-crafted reading themes, precise typography controls, and a focused reading environment.

- **4 Reader Themes** — White, Sepia, Dark Blue, AMOLED Black
- **4 Typefaces** — Merriweather, Georgia, Lexend, System
- **Line height** — Adjustable from 1.0× to 2.5×
- **Auto-scroll** — Configurable speed with Ticker-based animation
- **Orientation lock** — Portrait / landscape toggle directly from the reader
- **Publisher defaults** — One tap to restore original EPUB styles

---

### 🖊 Annotations

Build a personal knowledge base directly inside your books.

- **5 highlight colors** — Yellow, Green, Blue, Pink, Orange, rendered inline via CSS span injection
- **Rich-text notes** — Full Quill editor attached to every highlight
- **Bookmarks** — Chapter-level with exact scroll position restore
- **Vocabulary list** — Every word you look up, grouped by book
- **Per-book Markdown export** — Share all highlights and notes via any app
- **Styled quote sharing** — Designed image cards with book title and author credit
- **Full-text search** — Across all chapters (EPUB) or pages (PDF) with result highlighting

---

### 🎧 Audiobook Player

A full audiobook player built directly into the reading screen — no switching apps.

- Multi-file import with reorderable track list
- Variable speed playback from 0.5× to 2.0× in 0.25× increments
- Auto-save position every 10 seconds, seamless resume on reopen
- Skip forward / backward 30 seconds
- Chapter navigation sheet with track reordering

---

### 📚 Library Management

- MD5 content-hash deduplication — identical files are never imported twice
- Filter by author, genre, series, tag, format (EPUB / PDF), or read status
- Sort by title, author, or recently added — ascending or descending
- Multi-select with batch tagging and deletion
- Soft-delete with restore; hard-delete cascades to all associated annotations
- Favorites, custom tags, series grouping, folder tracking

---

### 🔔 Notifications

- Daily reading reminder at a user-configured time
- Weekend 2× WP boost notification (Saturday and Sunday, 10 AM)
- All notification channels individually configurable from Settings

---

## 🏆 Wisdom Progression System

Reading is not a task — it is a journey toward wisdom.

Tibeb transforms your reading into a structured progression system rooted in the Ge'ez scholarly tradition of Ethiopia. **Consistency, curiosity, and reflection are rewarded** over raw completion.

### Wisdom Points (WP)

Every reading session earns Wisdom Points:

| Action | Base WP | Multiplier |
|--------|--------:|-----------|
| PDF — per page | 10 WP | — |
| EPUB — per chapter | 40 WP | — |
| Any format — per minute | 5 WP | — |
| **Early Bird** (6–9 AM) | above rates | **1.5×** |
| **Night Owl** (10 PM–1 AM) | above rates | **1.5×** |
| **Weekend** session | above rates | **2×** |
| Completed daily quest | flat bonus WP | varies per quest |

**Every 1,000 WP = 1 Level** (maximum level 99).

---

### 🌿 The Six Ge'ez Ranks

Every reader grows through a structured journey rooted in Ethiopian scholarly tradition:

```text
🌱 Temari    (ተማሪ)       Level  1  •   0 achievements  —  The Learner
        ↓
📖 Anebabi   (አንባቢ)      Level  5  •   2 achievements  —  The Reader
        ↓
✍️ Tsehafi   (ፀሐፊ)       Level 10  •   5 achievements  —  The Scribe
        ↓
🎓 Liq       (ሊቅ)        Level 20  •   8 achievements  —  The Scholar
        ↓
🧠 Baletibeb (ባለ ጥበብ)   Level 40  •  10 achievements  —  The Wise One
        ↓
👑 Tibebawi  (ጥበባዊ)       Level 50  •  12 achievements  —  Embodiment of Wisdom
```

Each rank requires **both a minimum level and a minimum number of achievements** — reflecting that wisdom is earned through depth, not just time.

---

### 🎖 18 Achievements

Achievements reward **habits, depth, and consistency** — not just completion.

| Achievement | Condition |
|-------------|-----------|
| **The First Page** | Finish your first book |
| **Habit Builder** | 3-day reading streak |
| **7-Day Streak** | 7 consecutive days |
| **Bookworm** | 1,000 total pages read |
| **Night Owl** | Read after 10 PM |
| **Early Bird** | Read before 9 AM |
| **Century Club** | 100+ pages in a single session |
| **Unstoppable** | 30-day reading streak |
| **Marathoner** | 2 hours in a single session |
| **Scholar** | 5,000 total pages read |
| **Yomibito** | Finish 10 books |
| **Sensei** | Finish 50 books |
| **Bibliophile** | 10 books in library |
| **Collector** | 100 books in library |
| **Weekend Warrior** | Read on both Saturday and Sunday in the same weekend |
| **Word Seeker** | First dictionary lookup |
| **Vocab Builder** | 20 total vocabulary lookups |
| **Lexicoguru** | 100 total vocabulary lookups |

---

### 📅 Daily Quests

Three fresh quests every day, with **2× WP rewards on weekends**:

- **Daily Reader** — Read 5 pages today
- **Deep Focus** — Read for 15 minutes
- **Early Bird** — Read before 9:00 AM

All quests reset daily and are stored in the Drift database with completion history.

---

### 📊 Stats & Activity

- GitHub-style monthly activity heatmap with 5 intensity levels
- Weekly goals for pages, minutes, or WP — fully editable via sheet
- Streak tracking with live display and historical view
- Level card with circular WP progress bar and rank metadata detail sheet
- Tap the level card to view all 6 Ge'ez ranks with unlock criteria

---

### 🌍 Internationalization & Localization

Tibeb is fully internationalized and localized supporting 4 languages natively across the interface, onboarding systems, and screen modules (including Audiobook Player, Google Image Search, File Picker, and Tutorial systems):
- **English** (en)
- **Amharic** (am — አማርኛ)
- **Tigrinya** (ti — ትግርኛ)
- **Afaan Oromo** (om — Oromoo)

---

## 🏗 Architecture

Tibeb is built on a clean, layered architecture with a type-safe Drift database at its core.

```
lib/
├── core/
│   ├── database/              # Drift AppDatabase + 6 typed tables + 6 DAOs
│   │   ├── daos/              # BooksDao, HighlightsDao, BookmarksDao,
│   │   │                      #   QuestsDao, ReadingSessionsDao, DictionaryLookupsDao
│   │   ├── tables.dart        # Typed schema with FK constraints + ON DELETE CASCADE
│   │   ├── audio_track_converter.dart   # TypeConverter<List<AudioTrack>, String>
│   │   └── database.dart      # AppDatabase — WAL journal, FK enforcement on open
│   ├── repositories/
│   │   ├── database_repository.dart     # Abstract interface + DatabaseRepositoryImpl
│   │   └── mappers.dart                 # Entity ↔ domain extension methods
│   ├── rank/                  # TibebRank model, repository, Ge'ez rank data
│   └── theme/                 # Token-based design system — 50+ component categories
│
├── models/                    # 7 domain models: Book, Highlight, Bookmark,
│                              #   DailyQuest, ReaderSettings, SearchResult, VocabularyLookup
├── providers/
│   ├── library_provider.dart  # LibraryNotifier — library, WP, streak, achievements, quests
│   ├── reader_settings_provider.dart    # ReaderSettingsNotifier — themes, fonts, line height
│   └── database_providers.dart          # Riverpod wiring for AppDatabase + DatabaseRepository
├── screens/                   # 9 feature screens
├── services/
│   ├── book_service.dart      # File import pipeline — EPUB metadata, MD5 deduplication
│   └── notification_service.dart        # Local notifications — reminders + WP boosts
└── widgets/
    ├── book_card/             # 8-file decomposed book card (cover, info, badges, gestures…)
    ├── reading/               # 14 reading widgets (epub, pdf, audio, annotations, search…)
    ├── stats/                 # 5 stats widgets (level card, goals, achievements, rank sheet…)
    ├── dashboard/             # 3 dashboard widgets (continue reading, header, shelf item)
    ├── empty_state/           # Empty state token infrastructure
    ├── error_state/           # Error state token infrastructure
    └── loading/               # Loading widget tokens
```

### Database Schema — Drift (SQLite)

Tibeb uses [Drift](https://drift.simonbinder.eu/) — a type-safe, reactive SQLite library with code generation — as its persistence layer. All raw SQL is gone; every query is typed.

| Table | Purpose | FK Cascade |
|-------|---------|:----------:|
| `books` | Library entries, progress, audio track list (JSON via TypeConverter) | — |
| `reading_sessions` | Per-session page count + minutes for WP / streak calculation | ✅ |
| `bookmarks` | Chapter-level bookmarks with exact scroll position | ✅ |
| `highlights` | 5-color highlights with optional rich-text notes | ✅ |
| `quests` | Daily quest definitions, progress, and WP rewards | — |
| `dictionary_lookups` | Vocabulary lookup history | ✅ |

All child records are automatically removed when their parent book is hard-deleted — enforced at the SQLite layer via `ON DELETE CASCADE`, not application logic.

`PRAGMA foreign_keys = ON` and `PRAGMA journal_mode = WAL` are applied on every database open.

---

## 🛠 Tech Stack

| Category | Library | Version |
|----------|---------|---------|
| Framework | Flutter | ^3.10.7 |
| Language | Dart | ^3.10.7 |
| State Management | flutter_riverpod | ^3.3.2 |
| Database | drift + sqlite3 | ^2.34.0 |
| EPUB | epubx | ^4.0.0 |
| PDF | pdfrx | ^2.4.4 |
| Audio | just_audio | ^0.10.6 |
| Rich-text Notes | flutter_quill | ^11.5.0 |
| Fonts | google_fonts | ^8.1.0 |
| Animations | flutter_animate + animations | ^4.5.2 |
| File Picker | file_picker | ^11.0.2 |
| Notifications | flutter_local_notifications | ^22.0.1 |
| Navigation | go_router | ^17.3.0 |
| Share | share_plus | ^12.0.1 |
| Tutorial Overlay | tutorial_coach_mark | ^1.3.3 |

---

## 🚦 Getting Started

### Prerequisites

- Flutter SDK `^3.10.7`
- Dart SDK `^3.10.7`
- Android Studio or VS Code with the Flutter and Dart extensions

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/your-username/tibeb.git
cd tibeb

# 2. Install dependencies
flutter pub get

# 3. Generate Drift database code
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app on a connected device or emulator
flutter run
```

### Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Google Play)
flutter build appbundle --release
```

---

## 🤝 Contributing

Contributions are welcome. Before starting anything significant, open an issue or a discussion to align on scope and approach — this avoids duplicated effort and makes reviews faster.

### Branch Naming

Use a descriptive prefix that reflects the nature of the change:

| Type | Prefix | Example |
|------|--------|---------|
| Bug fix | `fix/` | `fix/epub-crash-on-empty-chapter` |
| New feature | `feat/` | `feat/sleep-timer-audio-playback` |
| Refactor | `refactor/` | `refactor/extract-gamification-notifier` |
| Documentation | `docs/` | `docs/drift-schema-diagram` |
| Performance | `perf/` | `perf/stream-epub-file-hash` |
| Testing | `test/` | `test/highlights-dao-crud` |
| Style / UI | `ui/` | `ui/reader-theme-sepia-contrast` |

```bash
git checkout -b feat/sleep-timer-audio-playback
```

### Code Standards

- Match the style, structure, and naming conventions already in the codebase — don't introduce new patterns without discussion.
- Keep changes focused. One concern per pull request.
- For database schema changes, provide a Drift migration in `AppDatabase.migration.onUpgrade` — do not bump `schemaVersion` without a migration.
- For UI changes, use the token-based design system (`TibebThemeExtension`) rather than hardcoded colors or sizes.
- Do not add new global state to `LibraryNotifier` without first opening an issue to discuss whether a new notifier is more appropriate.

### Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short description>
```

```bash
git commit -m "feat(audio): add sleep timer with configurable duration options"
git commit -m "fix(epub): prevent crash when chapter HTML content is null"
git commit -m "refactor(provider): extract GamificationNotifier from LibraryNotifier"
git commit -m "test(dao): add unit tests for HighlightsDao CRUD and cascade delete"
git commit -m "perf(import): replace full-file MD5 read with streaming chunked hash"
git commit -m "docs(readme): add Drift schema table and architecture diagram"
```

### Pull Request Checklist

Before opening a PR, confirm:

- [ ] `flutter analyze` passes with no errors or warnings
- [ ] `flutter test` passes (add tests for any new business logic)
- [ ] The change is scoped to one concern
- [ ] The PR description explains **what**, **why**, and **how it was tested**
- [ ] Screenshots or recordings are included for any UI changes
- [ ] No hardcoded colors, sizes, or strings that belong in the design system or localization files

```bash
git push origin feat/sleep-timer-audio-playback
```

### Good First Issues

Well-scoped, self-contained improvements to get started:

- Add `operator ==` and `hashCode` to all 7 domain model classes
- Implement the actual `EmptyState` and `ErrorState` widgets (token infrastructure already exists in `widgets/empty_state/` and `widgets/error_state/`)
- Add CSS hyphenation to the EPUB renderer — `hyphens: auto; -webkit-hyphens: auto;` in `epub_chapter_page.dart`
- Add `copyWith()` to `BookmarkModel`
- Write unit tests for `_calculateStreak()` edge cases using an in-memory Drift database
- Add Drift `@TableIndex` annotations on `bookId`, `date`, `createdAt` columns for query performance

---

## 🗺 Roadmap

### Phase 1 — Stabilization
- [ ] Error boundaries and graceful crash recovery UI
- [ ] Drift DB encryption via `sqlcipher_flutter_libs` + `flutter_secure_storage`
- [ ] Database indices (`@TableIndex`) for query performance at scale
- [ ] Streaming MD5 file hash to prevent OOM on large imports
- [ ] CI/CD pipeline — GitHub Actions: lint → test → build
- [ ] Complete `EmptyState` and `ErrorState` widget implementations

### Phase 2 — MVP Completion
- [ ] Bundled Amharic font (Abyssinica SIL) in `assets/fonts/`
- [ ] Cross-book highlights browser with search and bulk export
- [ ] Sleep timer for audio playback
- [ ] Tag highlights — schema migration, editor input, filter by tag
- [ ] Font weight, horizontal margin, and letter spacing controls
- [ ] Encrypted local backup and restore (JSON + AES)
- [x] Amharic, Tigrinya, Afaan Oromo localizations — extract all strings to `.arb` files

### Phase 3 — Differentiation
- [ ] Cloud sync — Supabase / Firebase with offline-first conflict resolution
- [ ] Spaced repetition flashcards from highlights (SM-2 algorithm)
- [ ] Cross-book full-text search via Drift FTS5 virtual table
- [ ] CBZ / CBR comic reader
- [ ] Auto sunrise/sunset reader theme switching
- [ ] Wire `go_router` deep links throughout the app
- [ ] Firebase Analytics integration

### Phase 4 — The Vision
- [ ] Knowledge Graph — concepts and ideas linked across books
- [ ] AI passage explainer via Gemini API
- [ ] Audio-text synchronization (Whispersync-style)
- [ ] Amharic TTS — on-device read-aloud
- [ ] Amharic OCR — camera-based book scanning
- [ ] Universal web article capture
- [ ] MOBI / AZW3 import
- [ ] Plugin and extension system
- [ ] Ethiopian book marketplace

---

## 📄 License

Distributed under the **MIT License**. See [LICENSE](LICENSE) for details.

---

<div align="center">

Made with ❤️ for readers everywhere.

**Read. Listen. Reflect. Grow.**

</div>
