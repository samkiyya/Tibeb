import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/theme.dart';
import '../core/constants/app_constants.dart';
import '../providers/library_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings/settings_widgets.dart';
import '../widgets/glass_container.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;
    final libraryState = ref.watch(libraryProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: t.background,
      body: CustomScrollView(
        slivers: [
          // Modern header with gradient accent
          SliverAppBar(
            backgroundColor: Colors.transparent,
            floating: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                l10n.settings,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: t.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          
          SliverPadding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 100,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // User Profile Card - Hero Section
                _buildProfileCard(libraryState, t, l10n)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 0.ms)
                    .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 0.ms),
                
                const SizedBox(height: 24),
                
                // Quick Settings Grid
                _buildQuickSettingsGrid(context, ref, l10n, t)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 100.ms)
                    .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 100.ms),
                
                const SizedBox(height: 32),
                
                // Reading Preferences Section
                _buildSectionHeader(l10n.readingPreferences, Icons.menu_book_rounded, t),
                const SizedBox(height: 12),
                _buildReadingPreferences(context, ref, l10n, t)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 200.ms)
                    .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 200.ms),
                
                const SizedBox(height: 32),
                
                // App Experience Section
                _buildSectionHeader(l10n.appExperience, Icons.tune_rounded, t),
                const SizedBox(height: 12),
                _buildAppExperience(context, ref, l10n, t)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 300.ms)
                    .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 300.ms),
                
                const SizedBox(height: 32),
                
                // Support & About Section
                _buildSectionHeader(l10n.supportAbout, Icons.info_rounded, t),
                const SizedBox(height: 12),
                _buildSupportSection(context, ref, l10n, t)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 400.ms)
                    .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 400.ms),
                
                const SizedBox(height: 48),
                
                // Version Info
                const AboutSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(LibraryState state, TibebThemeExtension t, AppLocalizations l10n) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Avatar with level badge
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      t.primary,
                      t.primary.withValues(alpha: 0.7),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: t.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    state.rankName.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: t.streakFire,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: t.background, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department, size: 10, color: Colors.white),
                      const SizedBox(width: 2),
                      Text(
                        '${state.currentStreak}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.rankName,
                  style: TextStyle(
                    color: t.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.level} ${state.level} • ${state.totalWP} WP',
                  style: TextStyle(
                    color: t.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                // Progress bar
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: t.glass,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: (state.totalWP % 1000) / 1000,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [t.primary, t.primary.withValues(alpha: 0.6)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Chevron
          Icon(
            Icons.chevron_right_rounded,
            color: t.textTertiary,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, TibebThemeExtension t) {
    return Row(
      children: [
        Icon(icon, color: t.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: t.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSettingsGrid(BuildContext context, WidgetRef ref, AppLocalizations l10n, TibebThemeExtension t) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickSettingTile(
            icon: Icons.palette_rounded,
            label: l10n.theme,
            onTap: () => _showThemeBottomSheet(context, ref, l10n, t),
            t: t,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickSettingTile(
            icon: Icons.notifications_rounded,
            label: l10n.alerts,
            onTap: () => _showNotificationBottomSheet(context, ref, l10n, t),
            t: t,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickSettingTile(
            icon: Icons.language_rounded,
            label: l10n.language,
            onTap: () => _showLanguageBottomSheet(context, ref, l10n, t),
            t: t,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSettingTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required TibebThemeExtension t,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: t.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: t.primary, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: t.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingPreferences(BuildContext context, WidgetRef ref, AppLocalizations l10n, TibebThemeExtension t) {
    return GlassContainer(
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.text_fields_rounded,
            title: l10n.fontSettings,
            subtitle: l10n.customizeReadingExperience,
            onTap: () => _showFontSettingsSheet(context, t, l10n),
            t: t,
          ),
          Divider(color: t.borderSubtle, height: 1),
          _buildSettingsTile(
            icon: Icons.auto_stories_rounded,
            title: l10n.displayMode,
            subtitle: l10n.pageLayoutOrientation,
            onTap: () => _showDisplaySettingsSheet(context, t, l10n),
            t: t,
          ),
          Divider(color: t.borderSubtle, height: 1),
          _buildSettingsTile(
            icon: Icons.speed_rounded,
            title: l10n.readingSpeed,
            subtitle: l10n.autoScrollPacing,
            onTap: () => _showReadingSpeedSheet(context, t, l10n),
            t: t,
          ),
        ],
      ),
    );
  }

  Widget _buildAppExperience(BuildContext context, WidgetRef ref, AppLocalizations l10n, TibebThemeExtension t) {
    return GlassContainer(
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.notifications_active_rounded,
            title: l10n.dailyReminders,
            subtitle: l10n.keepReadingStreakAlive,
            value: ref.watch(settingsProvider).notificationsEnabled,
            onChanged: (val) {
              ref.read(settingsProvider.notifier).updateNotificationSettings(enabled: val);
              ref.read(libraryProvider.notifier).updateNotificationSettings(enabled: val);
            },
            t: t,
          ),
          Divider(color: t.borderSubtle, height: 1),
          _buildSettingsTile(
            icon: Icons.shield_rounded,
            title: l10n.privacy,
            subtitle: l10n.dataPermissions,
            onTap: () => _showPrivacySettingsSheet(context, t, l10n),
            t: t,
          ),
          Divider(color: t.borderSubtle, height: 1),
          _buildSettingsTile(
            icon: Icons.storage_rounded,
            title: l10n.storage,
            subtitle: l10n.manageAppData,
            onTap: () => _showStorageSettingsSheet(context, t, l10n),
            t: t,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context, WidgetRef ref, AppLocalizations l10n, TibebThemeExtension t) {
    return GlassContainer(
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.volunteer_activism_rounded,
            title: l10n.supportDeveloper,
            subtitle: l10n.helpSupportProject,
            onTap: () => ref.read(settingsProvider.notifier).launchUrl(AppConstants.supportUrl),
            t: t,
          ),
          Divider(color: t.borderSubtle, height: 1),
          _buildSettingsTile(
            icon: Icons.code_rounded,
            title: l10n.contribute,
            subtitle: l10n.helpBuildGitHub,
            onTap: () => ref.read(settingsProvider.notifier).launchUrl(AppConstants.githubUrl),
            t: t,
          ),
          Divider(color: t.borderSubtle, height: 1),
          _buildSettingsTile(
            icon: Icons.star_rate_rounded,
            title: l10n.rateApp,
            subtitle: l10n.leaveReview,
            onTap: () => ref.read(settingsProvider.notifier).rateApp(),
            t: t,
          ),
          Divider(color: t.borderSubtle, height: 1),
          _buildSettingsTile(
            icon: Icons.share_rounded,
            title: l10n.shareApp,
            subtitle: l10n.shareWithFriends,
            onTap: () => ref.read(settingsProvider.notifier).shareApp(),
            t: t,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
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

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
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
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: t.primary,
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context, WidgetRef ref, AppLocalizations l10n, TibebThemeExtension t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: GlassContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.theme,
                style: TextStyle(
                  color: t.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const ThemeSelector(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationBottomSheet(BuildContext context, WidgetRef ref, AppLocalizations l10n, TibebThemeExtension t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: GlassContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.notifications,
                style: TextStyle(
                  color: t.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const NotificationSettings(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context, WidgetRef ref, AppLocalizations l10n, TibebThemeExtension t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: GlassContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.language,
                style: TextStyle(
                  color: t.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const LanguageToggle(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showFontSettingsSheet(BuildContext context, TibebThemeExtension t, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GlassContainer(
            padding: const EdgeInsets.all(20),
            child: const FontSettingsSheet(),
          ),
        ),
      ),
    );
  }

  void _showDisplaySettingsSheet(BuildContext context, TibebThemeExtension t, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GlassContainer(
            padding: const EdgeInsets.all(20),
            child: const DisplaySettingsSheet(),
          ),
        ),
      ),
    );
  }

  void _showPrivacySettingsSheet(BuildContext context, TibebThemeExtension t, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GlassContainer(
            padding: const EdgeInsets.all(20),
            child: const PrivacySettingsSheet(),
          ),
        ),
      ),
    );
  }

  void _showStorageSettingsSheet(BuildContext context, TibebThemeExtension t, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GlassContainer(
            padding: const EdgeInsets.all(20),
            child: const StorageSettingsSheet(),
          ),
        ),
      ),
    );
  }

  void _showReadingSpeedSheet(BuildContext context, TibebThemeExtension t, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GlassContainer(
            padding: const EdgeInsets.all(20),
            child: const ReadingSpeedSheet(),
          ),
        ),
      ),
    );
  }
}