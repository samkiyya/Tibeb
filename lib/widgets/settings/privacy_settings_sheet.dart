import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../../core/theme/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/app_constants.dart';

class PrivacySettingsSheet extends ConsumerWidget {
  const PrivacySettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.privacy,
            style: TextStyle(
              color: t.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          _buildPrivacyTile(
            icon: Icons.privacy_tip_rounded,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () => _launchUrl(AppConstants.privacyPolicyUrl),
            t: t,
          ),
          const SizedBox(height: 8),
          _buildPrivacyTile(
            icon: Icons.gavel_rounded,
            title: 'Terms of Service',
            subtitle: 'Read our terms of service',
            onTap: () => _launchUrl(AppConstants.termsOfServiceUrl),
            t: t,
          ),
          const SizedBox(height: 8),
          _buildPrivacyTile(
            icon: Icons.security_rounded,
            title: 'Data Collection',
            subtitle: 'What data we collect and why',
            onTap: () => _showDataCollectionDialog(context, t, l10n),
            t: t,
          ),
          const SizedBox(height: 8),
          _buildPrivacyTile(
            icon: Icons.delete_rounded,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            onTap: () => _showDeleteAccountDialog(context, t, l10n),
            t: t,
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPrivacyTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required TibebThemeExtension t,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: t.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: t.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: t.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: t.textSecondary,
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: t.textTertiary,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri, mode: launcher.LaunchMode.externalApplication);
    }
  }

  void _showDataCollectionDialog(BuildContext context, TibebThemeExtension t, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: t.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Data Collection',
          style: TextStyle(
            color: t.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            'tibeb collects the following data:\n\n'
            '• Reading progress and statistics\n'
            '• App settings and preferences\n'
            '• Device information for compatibility\n\n'
            'All data is stored locally on your device. We do not collect personal information or share your data with third parties.',
            style: TextStyle(color: t.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.gotIt,
              style: TextStyle(color: t.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, TibebThemeExtension t, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: t.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Account',
          style: TextStyle(
            color: t.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'This will permanently delete all your data including reading progress, settings, and statistics. This action cannot be undone.',
          style: TextStyle(color: t.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.maybeLater,
              style: TextStyle(color: t.textTertiary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Account deletion will be implemented soon',
                    style: TextStyle(color: t.textPrimary),
                  ),
                  backgroundColor: t.surface,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: t.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}