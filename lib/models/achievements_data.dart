// lib/data/achievements_data.dart
import 'package:flutter/material.dart';
import '../models/achievement.dart';

final List<Achievement> allAchievements = [
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
  title: 'Anebabi\'s Path',
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
  title: 'Guba\'e Marathon',
  description: '100+ pages read in one go (ጉባኤ ማራቶን)',
  icon: Icons.rocket_launch_rounded,
),

const Achievement(
  id: 'unstoppable',
  title: 'Tsehafi\'s Devotion',
  description: 'Read for 30 days in a row (የፀሐፊ ጽናት)',
  icon: Icons.emoji_events_rounded,
),

const Achievement(
  id: 'marathoner',
  title: 'Tse\'at Vigil',
  description: 'Read for 2 hours in one go (የሰዓታት ትጋት)',
  icon: Icons.hourglass_full_rounded,
),

const Achievement(
  id: 'scholar',
  title: 'Liq\'s Library',
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
  title: 'Baletibeb\'s Archive',
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
 
];