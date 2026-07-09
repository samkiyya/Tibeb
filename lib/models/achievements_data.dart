// lib/models/achievements_data.dart
import 'package:flutter/material.dart';
import '../models/achievement.dart';

/// Complete list — all original 18 achievements preserved, new ones appended.
final List<Achievement> allAchievements = [

  // ── ORIGINAL 18 ──────────────────────────────────────────────────────────

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
    description: 'Total 1,000 pages read (ድጓ ሰብሳቢ)',
    icon: Icons.layers_rounded,
  ),
  const Achievement(
    id: 'night_owl',
    title: 'Kidan Nocturnal',
    description: 'Read books after 10 PM (ኪዳን)',
    icon: Icons.bedtime_rounded,
  ),
  const Achievement(
    id: 'early_bird',
    title: 'Mahlet Dawn',
    description: 'Read books before 9 AM (ማሕሌት)',
    icon: Icons.wb_twilight_rounded,
  ),
  const Achievement(
    id: 'century_club',
    title: "Guba'e Marathon",
    description: '100+ pages read in one go (ጉባኤ ማራቶን)',
    icon: Icons.rocket_launch_rounded,
  ),
  const Achievement(
    id: 'unstoppable',
    title: "Tsehafi's Devotion",
    description: 'Read for 30 days in a row (የፀሐፊ ጽናት)',
    icon: Icons.emoji_events_rounded,
  ),
  const Achievement(
    id: 'marathoner',
    title: "Tse'at Vigil",
    description: 'Read for 2 hours in one go (የሰዓታት ትጋት)',
    icon: Icons.hourglass_full_rounded,
  ),
  const Achievement(
    id: 'scholar',
    title: "Liq's Library",
    description: 'Total 5,000 pages read (የሊቅ መጽሐፍት)',
    icon: Icons.account_balance_rounded,
  ),
  const Achievement(
    id: 'yomibito',
    title: 'Kibre Negest',
    description: 'Finish 10 books in total (ክብረ ነገሥት)',
    icon: Icons.workspace_premium_rounded,
  ),
  const Achievement(
    id: 'sensei',
    title: "Baletibeb's Archive",
    description: 'Finish 50 books in total (የባለጥበብ መዝገብ)',
    icon: Icons.diamond_rounded,
  ),
  const Achievement(
    id: 'bibliophile',
    title: 'Metsihaf Collector',
    description: 'Add 10 books to library (መጽሐፍ ወዳድ)',
    icon: Icons.library_add_rounded,
  ),
  const Achievement(
    id: 'collector',
    title: 'Gedam Archive',
    description: 'Add 100 books to library (የገዳም መዛግብት)',
    icon: Icons.domain_rounded,
  ),
  const Achievement(
    id: 'weekend_warrior',
    title: 'Sabbath Scholar',
    description: 'Read on both Sat and Sun (የሰንበት ተማሪ)',
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
    description: 'Total 20 words looked up (የሰዋስው ተማሪ)',
    icon: Icons.spellcheck_rounded,
  ),
  const Achievement(
    id: 'polyglot',
    title: 'Liqe Tergum',
    description: 'Total 100 words looked up (ሊቀ ትርጉም)',
    icon: Icons.psychology_alt_rounded,
  ),

  // ── NEW: Pages milestones ─────────────────────────────────────────────────

  const Achievement(
    id: 'gondar_keep',
    title: "Gondar's Keep",
    description: 'Read 500 pages total (የጎንደር ምሽግ)',
    icon: Icons.history_edu_rounded,    // history scroll = Gondar castle chronicles
  ),
  const Achievement(
    id: 'sheba_wisdom',
    title: "Sheba's Wisdom",
    description: 'Read 2,000 pages total (የሳባ ጥበብ)',
    icon: Icons.emoji_objects_rounded,  // lightbulb = Queen of Sheba's legendary wisdom
  ),
  const Achievement(
    id: 'axum_legacy',
    title: "Axum's Legacy",
    description: 'Read 10,000 pages total (የአክሱም ቅርስ)',
    icon: Icons.museum_rounded,         // museum = the enduring heritage of Axum
  ),

  // ── NEW: Books finished milestones ────────────────────────────────────────

  const Achievement(
    id: 'fasil_crown',
    title: "Fasil's Crown",
    description: 'Finish 5 books in total (የፋሲል ዘውድ)',
    icon: Icons.verified_rounded,       // verified seal = Fasilides' royal crown
  ),
  const Achievement(
    id: 'yohannes_torch',
    title: "Yohannes' Torch",
    description: 'Finish 20 books in total (የዮሐንስ ችቦ)',
    icon: Icons.auto_awesome_rounded,   // sparkle = Emperor Yohannes lighting knowledge
  ),
  const Achievement(
    id: 'menelik_library',
    title: "Menelik's Library",
    description: 'Finish 100 books in total (የምኒልክ ቤተ መጻሕፍት)',
    icon: Icons.architecture_rounded,   // architecture = Menelik's grand palace library
  ),

  // ── NEW: Time/hours milestones ────────────────────────────────────────────

  const Achievement(
    id: 'lalibela_vigil',
    title: "Lalibela's Vigil",
    description: 'Read for 100 total hours (የላሊበላ ጥንቃቄ)',
    icon: Icons.church_rounded,         // church = Lalibela's rock-hewn church devotion
  ),

  // ── NEW: Streak milestones ────────────────────────────────────────────────

  const Achievement(
    id: 'selassie_endurance',
    title: "Selassie's Endurance",
    description: 'Read for 100 days in a row (የሥላሴ ጽናት)',
    icon: Icons.timeline_rounded,       // timeline = the long arc of regal endurance
  ),

  // ── NEW: Vocabulary milestones ────────────────────────────────────────────

  const Achievement(
    id: 'geez_mastery',
    title: 'Geez Mastery',
    description: 'Look up 500 words total (የግዕዝ ዕውቀት)',
    icon: Icons.translate_rounded,      // translation = mastery of Ge'ez classical script
  ),
  const Achievement(
    id: 'qene_poet',
    title: 'Qene Poet',
    description: 'Look up 1,000 words total (ቅኔ ባለቅኔ)',
    icon: Icons.edit_note_rounded,      // poet's pen = Ethiopia's sacred Qene poetry
  ),

  // ── NEW: Audiobook achievements ───────────────────────────────────────────

  const Achievement(
    id: 'oral_tradition',
    title: 'Oral Tradition',
    description: 'Listen to your first audiobook (የቃል ትውፊት)',
    icon: Icons.headphones_rounded,     // headphones = Ethiopia's living oral storytelling
  ),
  const Achievement(
    id: 'azmari_listener',
    title: 'Azmari Listener',
    description: 'Listen to 5 audiobooks (አዝማሪ ሰሚ)',
    icon: Icons.queue_music_rounded,    // music queue = Azmari wandering minstrel tradition
  ),

  // ── NEW: Speed & dedication ───────────────────────────────────────────────

  const Achievement(
    id: 'fast_reader',
    title: "Behailu's Speed",
    description: 'Finish a book in under 3 days (የፍጥነት ንባብ)',
    icon: Icons.speed_rounded,          // speedometer = reading with swift determination
  ),
  const Achievement(
    id: 'annotations_scholar',
    title: 'Margin Notes',
    description: 'Add 20 highlights or bookmarks (የሽፋን ማስታወሻ)',
    icon: Icons.bookmark_added_rounded, // bookmark = the scholar's annotated manuscript
  ),

  // ── NEW: Seasonal / special ───────────────────────────────────────────────

  const Achievement(
    id: 'timkat_reader',
    title: 'Timkat Reader',
    description: 'Read on Ethiopian Epiphany (ጥምቀት ቀን)',
    icon: Icons.water_rounded,          // water = the Timkat baptism ceremony
  ),
  const Achievement(
    id: 'enkutatash_start',
    title: 'Enkutatash Awakening',
    description: 'Read on Ethiopian New Year (እንቁጣጣሽ ቀን)',
    icon: Icons.celebration_rounded,    // celebration = Ethiopian New Year (Sep 11)
  ),
  const Achievement(
    id: 'adwa_spirit',
    title: 'Adwa Spirit',
    description: 'Read for 7 consecutive weeks (የዓድዋ መንፈስ)',
    icon: Icons.flag_rounded,           // flag = the Battle of Adwa victory spirit
  ),
  const Achievement(
    id: 'meskel_flame',
    title: 'Meskel Flame',
    description: 'Read 3 books in one month (የመስቀል ነበልባል)',
    icon: Icons.local_fire_department_rounded, // flame = the Meskel bonfire of Finding the Cross
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