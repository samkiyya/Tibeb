import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/settings_provider.dart';

class SupportSection extends ConsumerWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;

    return Column(
      children: [
        _buildSupportTile(
          t: t,
          icon: Icons.volunteer_activism_rounded,
          title: 'Support the Developer',
          subtitle: 'Support the developer and the project ❤️',
          onTap: () => ref.read(settingsProvider.notifier).launchUrl(AppConstants.supportUrl),
        ),
        Divider(color: t.borderSubtle, height: 1),
        _buildSupportTile(
          t: t,
          icon: Icons.code_rounded,
          title: 'Contribute on GitHub',
          subtitle: 'Help build the future of tibeb 🚀',
          onTap: () => ref.read(settingsProvider.notifier).launchUrl(AppConstants.githubUrl),
        ),
        Divider(color: t.borderSubtle, height: 1),
        _buildSupportTile(
          t: t,
          icon: Icons.star_rate_rounded,
          title: 'Rate the App',
          subtitle: 'Love tibeb? Leave us a review! ⭐',
          onTap: () => ref.read(settingsProvider.notifier).rateApp(),
        ),
        Divider(color: t.borderSubtle, height: 1),
        _buildSupportTile(
          t: t,
          icon: Icons.share_rounded,
          title: 'Share the App',
          subtitle: 'Share tibeb with friends 📢',
          onTap: () => ref.read(settingsProvider.notifier).shareApp(),
        ),
      ],
    );
  }

  Widget _buildSupportTile({
    required TibebThemeExtension t,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: t.primary),
      title: Text(
        title,
        style: TextStyle(
          color: t.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: t.textSecondary, fontSize: 12),
      ),
      trailing: Icon(
        Icons.open_in_new_rounded,
        color: t.textTertiary,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}