import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/theme.dart';

import 'package:tibeb/providers/library_provider.dart';

class AchievementBadge extends StatelessWidget {
  final String title;
  final String desc;
  final IconData icon;
  final bool isUnlocked;

  const AchievementBadge({
    super.key,
    required this.title,
    required this.desc,
    required this.icon,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isUnlocked
                ? t.primary.withValues(alpha: 0.1)
                : t.glass,
            border: Border.all(
              color: isUnlocked ? t.primary : t.borderSubtle,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: isUnlocked ? t.primary : t.textSecondary,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isUnlocked ? t.textPrimary : t.textSecondary,
            fontSize: 10,
            fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          desc,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: t.textSecondary, fontSize: 8),
        ),
      ],
    );
  }
}

class AchievementsGrid extends StatelessWidget {
  final LibraryState state;

  const AchievementsGrid({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final achievementList = [
      {
        'id': 'the_first_page',
        'title': 'Fidel First',
        'desc': 'Finish your first book (ፊደል መጀመሪያ)',
        'icon': Icons.menu_book,
      },
      {
        'id': 'habit_builder',
        'title': 'Regular Temari',
        'desc': 'Read for 3 days in a row (ቋሚ ተማሪ)',
        'icon': Icons.trending_up,
      },
      {
        'id': 'seven_day_streak',
        'title': 'Anebabi\'s Path',
        'desc': 'Read for 7 days in a row (የአነባቢ መንገድ)',
        'icon': Icons.flash_on,
      },
      {
        'id': 'bookworm',
        'title': 'Degwa Collector',
        'desc': 'Total 1,000 pages read (ድጓ ሰብሳቢ)',
        'icon': Icons.bookmark_added_rounded,
      },
      {
        'id': 'night_owl',
        'title': 'Kidan Nocturnal',
        'desc': 'Read books after 10 PM (ኪዳን)',
        'icon': Icons.nightlight_round,
      },
      {
        'id': 'early_bird',
        'title': 'Mahlet Dawn',
        'desc': 'Read books before 9 AM (ማሕሌት)',
        'icon': Icons.wb_sunny,
      },
      {
        'id': 'century_club',
        'title': 'Guba\'e Marathon',
        'desc': '100+ pages read in one go (ጉባኤ ማራቶን)',
        'icon': Icons.military_tech,
      },
      {
        'id': 'unstoppable',
        'title': 'Tsehafi\'s Devotion',
        'desc': 'Read for 30 days in a row (የፀሐፊ ትጋት)',
        'icon': Icons.bolt,
      },
      {
        'id': 'marathoner',
        'title': 'Tse\'at Vigil',
        'desc': 'Read for 2 hours in one go (የሰዓታት ትጋት)',
        'icon': Icons.timer,
      },
      {
        'id': 'scholar',
        'title': 'Liq\'s Library',
        'desc': 'Total 5,000 pages read (የሊቅ መጽሐፍት)',
        'icon': Icons.history_edu,
      },
      {
        'id': 'yomibito',
        'title': 'Kibre Negest',
        'desc': 'Finish 10 books in total (ክብረ ነገሥት)',
        'icon': Icons.auto_stories,
      },
      {
        'id': 'sensei',
        'title': 'Baletibeb\'s Archive',
        'desc': 'Finish 50 books in total (የባለጥበብ መዝገብ)',
        'icon': Icons.school,
      },
      {
        'id': 'bibliophile',
        'title': 'Metsihaf Collector',
        'desc': 'Add 10 books to library (መጽሐፍ ወዳድ)',
        'icon': Icons.library_books,
      },
      {
        'id': 'collector',
        'title': 'Gedam Archive',
        'desc': 'Add 100 books to library (የገዳም መዛግብት)',
        'icon': Icons.collections_bookmark,
      },
      {
        'id': 'weekend_warrior',
        'title': 'Sabbath Scholar',
        'desc': 'Read on both Sat and Sun (የሰንበት ተማሪ)',
        'icon': Icons.church,
      },
      {
        'id': 'the_translator',
        'title': 'Tergum Seeker',
        'desc': 'Look up your first word (ትርጉም ፈላጊ)',
        'icon': Icons.search,
      },
      {
        'id': 'vocabulary_builder',
        'title': 'Sewasew Student',
        'desc': 'Total 20 words looked up (የሰዋስው ተማሪ)',
        'icon': Icons.translate_rounded,
      },
      {
        'id': 'polyglot',
        'title': 'Liqe Tergum',
        'desc': 'Total 100 words looked up (ሊቀ ትርጉም)',
        'icon': Icons.psychology,
      },
    ];

    final sortedList = List<Map<String, dynamic>>.from(achievementList);
    sortedList.sort((a, b) {
      final aUnlocked = state.unlockedAchievements.contains(a['id']);
      final bUnlocked = state.unlockedAchievements.contains(b['id']);
      if (aUnlocked == bUnlocked) return 0;
      return aUnlocked ? -1 : 1;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: t.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: sortedList.length,
          itemBuilder: (context, index) {
            final ach = sortedList[index];
            final isUnlocked = state.unlockedAchievements.contains(ach['id']);
            return GestureDetector(
              onTap: () => _showAchievementDetail(
                context,
                t,
                title: ach['title'] as String,
                desc: ach['desc'] as String,
                icon: ach['icon'] as IconData,
                isUnlocked: isUnlocked,
              ),
              child: AchievementBadge(
                title: ach['title'] as String,
                desc: ach['desc'] as String,
                icon: ach['icon'] as IconData,
                isUnlocked: isUnlocked,
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAchievementDetail(
    BuildContext context,
    TibebThemeExtension t, {
    required String title,
    required String desc,
    required IconData icon,
    required bool isUnlocked,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: t.surface,
        shape: RoundedRectangleBorder(borderRadius: TibebRadius.borderXl),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked
                    ? t.primary.withValues(alpha: 0.15)
                    : t.glass,
                border: Border.all(
                  color: isUnlocked ? t.primary : t.borderSubtle,
                  width: 2.5,
                ),
              ),
              child: Icon(
                icon,
                color: isUnlocked ? t.primary : t.textSecondary,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isUnlocked ? t.textPrimary : t.textSecondary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isUnlocked ? t.textSecondary : t.textSecondary.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isUnlocked ? 'Unlocked' : 'Keep reading to unlock!',
              style: TextStyle(
                color: isUnlocked ? t.primary : t.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
