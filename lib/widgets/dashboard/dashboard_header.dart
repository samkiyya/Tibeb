import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../../providers/library_provider.dart';
import '../../../l10n/app_localizations.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final libraryState = ref.watch(libraryProvider);
    final rankName = libraryState.getRankName(context);
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Positioned(
          top: -20,
          right: -20,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  t.primary.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE, MMM d').format(now).toUpperCase(),
              style: TextStyle(
                color: t.primary.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: now.hour < 12
                        ? '${l10n.goodMorning}, '
                        : now.hour < 17
                        ? '${l10n.goodAfternoon}, '
                        : '${l10n.goodEvening}, ',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                      color: t.textSecondary,
                      height: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: rankName,
                    style: context.textTheme.displayLarge?.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: t.textPrimary,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            _buildWPProgressBar(context, libraryState),
          ],
        ),
      ],
    );
  }

  Widget _buildWPProgressBar(BuildContext context, LibraryState state) {
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;
    final int currentWP = state.totalWP;
    final int nextLevelWP = (state.level) * 1000;
    final int currentLevelStartWP = (state.level - 1) * 1000;
    final double progress =
        ((currentWP - currentLevelStartWP) /
                (nextLevelWP - currentLevelStartWP))
            .clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${l10n.level} ${state.level}',
              style: TextStyle(
                color: t.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              '${currentWP % 1000} / 1000 WP',
              style: TextStyle(
                color: t.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: t.glass,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    t.primary,
                    t.primary.withValues(alpha: 0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: t.primary.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
