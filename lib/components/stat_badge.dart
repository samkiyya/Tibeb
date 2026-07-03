import 'package:flutter/material.dart';
import '../core/theme/theme.dart';

import './glass_container.dart';

class StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatBadge({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return GlassContainer(
      padding: const EdgeInsets.all(TibebSpacing.md),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: TibebSpacing.sm),
          Text(
            value,
            style: context.textTheme.titleLarge?.copyWith(fontSize: 18),
          ),
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: t.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
