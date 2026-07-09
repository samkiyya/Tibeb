import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../providers/library/library_state.dart';
import '../glass_container.dart';
import '../../l10n/app_localizations.dart';

class EngagementCard extends StatelessWidget {
  final LibraryState state;

  const EngagementCard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: t.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.stars_rounded, color: t.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.level} ${state.level}',
                  style: TextStyle(
                    color: t.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  state.rankName,
                  style: TextStyle(color: t.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${state.totalWP}',
                style: TextStyle(
                  color: t.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                l10n.totalWP,
                style: TextStyle(
                  color: t.textTertiary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}