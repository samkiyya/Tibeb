import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: t.primary.withValues(alpha: 0.8),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}