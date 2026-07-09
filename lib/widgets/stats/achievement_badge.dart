import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/theme.dart';

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
