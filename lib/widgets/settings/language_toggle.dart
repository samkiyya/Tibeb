import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme.dart';
import '../../core/constants/app_constants.dart';

class LanguageToggle extends ConsumerWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;

    if (!AppConstants.languageToggleEnabled) {
      return ListTile(
        leading: Icon(Icons.language_rounded, color: t.primary),
        title: Text(
          'Language',
          style: TextStyle(
            color: t.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Coming soon',
          style: TextStyle(color: t.textSecondary, fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: t.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Soon',
                style: TextStyle(
                  color: t.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: t.borderSubtle),
          ],
        ),
        onTap: () {
          // Show coming soon dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: t.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Coming Soon',
                style: TextStyle(
                  color: t.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'Language support is coming soon! We\'re working hard to bring you multiple language options.',
                style: TextStyle(color: t.textSecondary),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Got it',
                    style: TextStyle(color: t.primary),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    // When language toggle is enabled, show actual language selector
    return ListTile(
      leading: Icon(Icons.language_rounded, color: t.primary),
      title: Text(
        'Language',
        style: TextStyle(
          color: t.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'Select your preferred language',
        style: TextStyle(color: t.textSecondary, fontSize: 12),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: t.borderSubtle),
      onTap: () {
        // TODO: Implement language selector when enabled
      },
    );
  }
}