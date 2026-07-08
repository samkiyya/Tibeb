const Map<String, String> _achievementTitles = {
  'the_first_page': 'The First Page',
  'habit_builder': 'Habit Builder',
  'seven_day_streak': '7-Day Streak',
  'unstoppable': 'Unstoppable',
  'bookworm': 'Bookworm',
  'scholar': 'Scholar',
  'yomibito': 'Yomibito',
  'sensei': 'Sensei',
  'century_club': 'Century Club',
  'marathoner': 'Marathoner',
  'early_bird': 'Early Bird',
  'night_owl': 'Night Owl',
  'bibliophile': 'Bibliophile',
  'collector': 'Collector',
  'weekend_warrior': 'Weekend Warrior',
  'the_translator': 'Word Seeker',
  'vocabulary_builder': 'Vocab Builder',
  'polyglot': 'Lexicoguru',
};

/// Resolves the user-facing title for a given achievement key.
String achievementTitle(String key) {
  return _achievementTitles[key] ?? 'New Achievement';
}
