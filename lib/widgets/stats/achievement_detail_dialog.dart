// lib/widgets/achievement_detail_dialog.dart
import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/theme.dart';
import 'package:tibeb/models/achievement.dart';

class AchievementDetailDialog extends StatelessWidget {
  final Achievement achievement;

  const AchievementDetailDialog({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return AlertDialog(
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
              color: achievement.isUnlocked
                  ? t.primary.withValues(alpha: 0.15)
                  : t.glass,
              border: Border.all(
                color: achievement.isUnlocked ? t.primary : t.borderSubtle,
                width: 2.5,
              ),
            ),
            child: Icon(
              achievement.icon,
              color: achievement.isUnlocked ? t.primary : t.textSecondary,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: achievement.isUnlocked ? t.textPrimary : t.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            achievement.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: achievement.isUnlocked
                  ? t.textSecondary
                  : t.textSecondary.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            achievement.isUnlocked ? 'Unlocked' : 'Keep reading to unlock!',
            style: TextStyle(
              color: achievement.isUnlocked ? t.primary : t.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}