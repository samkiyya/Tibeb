import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/theme.dart';



class RankUpDialog extends StatelessWidget {
  final int level;
  final String rankName;

  const RankUpDialog({super.key, required this.level, required this.rankName});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: TibebSpacing.screenPadding),
      child: Container(
        padding: const EdgeInsets.all(TibebSpacing.xxl),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: TibebRadius.borderXxl,
          border: Border.all(
            color: t.primary.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: t.primary.withValues(alpha: 0.1),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        t.primary.withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.5, 1.5),
                      duration: 2.seconds,
                      curve: Curves.easeInOut,
                    )
                    .fadeOut(),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: t.primary.withValues(alpha: 0.1),
                    border: Border.all(color: t.primary, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      '$level',
                      style: context.textTheme.displaySmall?.copyWith(
                        color: t.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ).animate().scale(
                  delay: 200.ms,
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                ),
              ],
            ),
            const SizedBox(height: TibebSpacing.xl),
            Text(
              'RANK UP!',
              style: TextStyle(
                color: t.primary,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 4.0,
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: TibebSpacing.sm),
            Text(
              rankName,
              textAlign: TextAlign.center,
              style: context.textTheme.headlineLarge?.copyWith(
                color: t.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: TibebSpacing.base),
            Text(
              'You\'ve reached a new level of mastery.\nKeep reading to unlock more!',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: t.textSecondary,
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 800.ms),
            const SizedBox(height: TibebSpacing.xxl),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.primary,
                  foregroundColor: t.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: TibebRadius.borderLg,
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'AWESOME',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 1.seconds)
                .scale(begin: const Offset(0.9, 0.9)),
          ],
        ),
      ),
    );
  }
}
