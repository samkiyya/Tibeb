// lib/models/achievements_data.dart
import 'package:flutter/material.dart';
import '../models/achievement.dart';

/// Complete list — IDs preserved for compatibility.
final List<Achievement> allAchievements = [

  // ── Reading Journey ─────────────────────────────────────────────────────

  const Achievement(
    id: 'the_first_page',
    title: 'Fidel First',
    description: 'Finish your first book (ፊደል መጀመሪያ)',
    icon: Icons.auto_stories_rounded,
  ),

  const Achievement(
    id: 'habit_builder',
    title: 'Regular Temari',
    description: 'Read for 3 days in a row (ቋሚ ተማሪ)',
    icon: Icons.calendar_today_rounded,
  ),

  const Achievement(
    id: 'seven_day_streak',
    title: "Anebabi's Path",
    description: 'Read for 7 days in a row (የአነባቢ መንገድ)',
    icon: Icons.local_fire_department_rounded,
  ),

  const Achievement(
    id: 'bookworm',
    title: 'Degwa Collector',
    description: 'Read 1,000 pages in total (ድጓ ሰብሳቢ)',
    icon: Icons.layers_rounded,
  ),

  const Achievement(
    id: 'night_owl',
    title: 'Moonlight Reader',
    description: 'Read after 10 PM (የሌሊት አንባቢ)',
    icon: Icons.bedtime_rounded,
  ),

  const Achievement(
    id: 'early_bird',
    title: 'Dawn Scholar',
    description: 'Read before 9 AM (የንጋት ተማሪ)',
    icon: Icons.wb_twilight_rounded,
  ),

  const Achievement(
    id: 'century_club',
    title: 'Endurance Reader',
    description: 'Read 100 pages in one session (የረጅም ንባብ)',
    icon: Icons.rocket_launch_rounded,
  ),

  const Achievement(
    id: 'unstoppable',
    title: "Tsehafi's Devotion",
    description: 'Read for 30 consecutive days (የፀሐፊ ጽናት)',
    icon: Icons.emoji_events_rounded,
  ),

  const Achievement(
    id: 'marathoner',
    title: 'Reading Vigil',
    description: 'Read for 2 hours in one session (የንባብ ትጋት)',
    icon: Icons.hourglass_full_rounded,
  ),

  const Achievement(
    id: 'scholar',
    title: "Liq's Library",
    description: 'Read 5,000 pages in total (የሊቅ መጽሐፍት)',
    icon: Icons.account_balance_rounded,
  ),

  const Achievement(
    id: 'yomibito',
    title: 'Kibre Negest Scholar',
    description: 'Finish 10 books (ክብረ ነገሥት)',
    icon: Icons.workspace_premium_rounded,
  ),

  const Achievement(
    id: 'sensei',
    title: 'Master Liq',
    description: 'Finish 50 books (ሊቀ ሊቃውንት)',
    icon: Icons.diamond_rounded,
  ),

  const Achievement(
    id: 'bibliophile',
    title: 'Metsihaf Collector',
    description: 'Add 10 books to your library (መጽሐፍ ወዳድ)',
    icon: Icons.library_add_rounded,
  ),

  const Achievement(
    id: 'collector',
    title: 'Gedam Archive',
    description: 'Add 100 books to your library (የገዳም መዛግብት)',
    icon: Icons.domain_rounded,
  ),

  const Achievement(
    id: 'weekend_warrior',
    title: 'Sabbath Scholar',
    description: 'Read on both Saturday and Sunday (የሰንበት ተማሪ)',
    icon: Icons.brightness_5_rounded,
  ),

  const Achievement(
    id: 'the_translator',
    title: 'Tergum Seeker',
    description: 'Look up your first word (ትርጉም ፈላጊ)',
    icon: Icons.record_voice_over_rounded,
  ),

  const Achievement(
    id: 'vocabulary_builder',
    title: 'Sewasew Student',
    description: 'Look up 20 words (የሰዋስው ተማሪ)',
    icon: Icons.spellcheck_rounded,
  ),

  const Achievement(
    id: 'polyglot',
    title: 'Liqe Tergum',
    description: 'Look up 100 words (ሊቀ ትርጉም)',
    icon: Icons.psychology_alt_rounded,
  ),

  // ── Page Milestones ────────────────────────────────────────────────────

  const Achievement(
    id: 'gondar_keep',
    title: 'House of Manuscripts',
    description: 'Read 500 pages (የብራና ቤት)',
    icon: Icons.history_edu_rounded,
  ),

  const Achievement(
    id: 'sheba_wisdom',
    title: 'Wisdom of Sheba',
    description: 'Read 2,000 pages (የሳባ ጥበብ)',
    icon: Icons.emoji_objects_rounded,
  ),

  const Achievement(
    id: 'axum_legacy',
    title: 'Axum Heritage',
    description: 'Read 10,000 pages (የአክሱም ቅርስ)',
    icon: Icons.museum_rounded,
  ),

  // ── Books Finished ─────────────────────────────────────────────────────

  const Achievement(
    id: 'fasil_crown',
    title: 'Royal Reader',
    description: 'Finish 5 books (የንባብ ዘውድ)',
    icon: Icons.verified_rounded,
  ),

  const Achievement(
    id: 'yohannes_torch',
    title: 'Torch of Knowledge',
    description: 'Finish 20 books (የእውቀት ችቦ)',
    icon: Icons.auto_awesome_rounded,
  ),

  const Achievement(
    id: 'menelik_library',
    title: 'Grand Library',
    description: 'Finish 100 books (ቤተ መጻሕፍት)',
    icon: Icons.architecture_rounded,
  ),

  // ── Reading Time ───────────────────────────────────────────────────────

  const Achievement(
    id: 'lalibela_vigil',
    title: 'Lalibela Vigil',
    description: 'Read for 100 hours (የላሊበላ ትጋት)',
    icon: Icons.church_rounded,
  ),

  // ── Long Streak ────────────────────────────────────────────────────────

  const Achievement(
    id: 'selassie_endurance',
    title: 'Hundred-Day Scholar',
    description: 'Read for 100 consecutive days (የ100 ቀን ተማሪ)',
    icon: Icons.timeline_rounded,
  ),

  // ── Vocabulary ─────────────────────────────────────────────────────────

  const Achievement(
    id: 'geez_mastery',
    title: "Ge'ez Mastery",
    description: 'Look up 500 words (የግዕዝ ዕውቀት)',
    icon: Icons.translate_rounded,
  ),

  const Achievement(
    id: 'qene_poet',
    title: 'Qene Poet',
    description: 'Look up 1,000 words (ባለቅኔ)',
    icon: Icons.edit_note_rounded,
  ),

  // ── Audiobooks ─────────────────────────────────────────────────────────

  const Achievement(
    id: 'oral_tradition',
    title: 'Oral Tradition',
    description: 'Listen to your first audiobook (የቃል ትውፊት)',
    icon: Icons.headphones_rounded,
  ),

  const Achievement(
    id: 'azmari_listener',
    title: 'Azmari Listener',
    description: 'Listen to 5 audiobooks (አዝማሪ ሰሚ)',
    icon: Icons.queue_music_rounded,
  ),

  // ── Special Reading ────────────────────────────────────────────────────

  const Achievement(
    id: 'fast_reader',
    title: 'Swift Reader',
    description: 'Finish a book in under 3 days (ፈጣን አንባቢ)',
    icon: Icons.speed_rounded,
  ),

  const Achievement(
    id: 'annotations_scholar',
    title: 'Margin Scholar',
    description: 'Create 20 highlights or bookmarks (የጎን ማስታወሻ)',
    icon: Icons.bookmark_added_rounded,
  ),

  // ── Ethiopian Celebrations ─────────────────────────────────────────────

  const Achievement(
    id: 'timkat_reader',
    title: 'Timkat Reader',
    description: 'Read on Timkat (ጥምቀት)',
    icon: Icons.water_rounded,
  ),

  const Achievement(
    id: 'enkutatash_start',
    title: 'Enkutatash Awakening',
    description: 'Read on Enkutatash (እንቁጣጣሽ)',
    icon: Icons.celebration_rounded,
  ),

  const Achievement(
    id: 'adwa_spirit',
    title: 'Spirit of Adwa',
    description: 'Read for 7 consecutive weeks (የዓድዋ መንፈስ)',
    icon: Icons.flag_rounded,
  ),

  const Achievement(
    id: 'meskel_flame',
    title: 'Meskel Flame',
    description: 'Finish 3 books in one month (የመስቀል ነበልባል)',
    icon: Icons.local_fire_department_rounded,
  ),
];

String achievementTitle(String id) {
  return allAchievements.firstWhere(
    (a) => a.id == id,
    orElse: () => const Achievement(
      id: '',
      title: 'New Achievement',
      description: '',
      icon: Icons.help_outline_rounded,
    ),
  ).title;
}

Map<String, String> get achievementTitleMap =>
    Map.fromEntries(allAchievements.map((a) => MapEntry(a.id, a.title)));