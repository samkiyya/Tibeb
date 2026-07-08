const Map<String, String> _achievementTitles = {
  'the_first_page': 'Fidel First',
  'habit_builder': 'Regular Temari',
  'seven_day_streak': 'Anebabi\'s Path',
  'unstoppable': 'Tsehafi\'s Devotion',
  'bookworm': 'Degwa Collector',
  'scholar': 'Liq\'s Library',
  'yomibito': 'Kibre Negest',
  'sensei': 'Baletibeb\'s Archive',
  'century_club': 'Guba\'e Marathon',
  'marathoner': 'Tse\'at Vigil',
  'early_bird': 'Mahlet Dawn',
  'night_owl': 'Kidan Nocturnal',
  'bibliophile': 'Metsihaf Collector',
  'collector': 'Gedam Archive',
  'weekend_warrior': 'Sabbath Scholar',
  'the_translator': 'Tergum Seeker',
  'vocabulary_builder': 'Sewasew Student',
  'polyglot': 'Liqe Tergum',
};

/// Resolves the user-facing title for a given achievement key.
String achievementTitle(String key) {
  return _achievementTitles[key] ?? 'New Achievement';
}
