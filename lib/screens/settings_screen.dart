import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/theme.dart';
import '../providers/library_provider.dart';
import '../widgets/settings/settings_widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;
    final libraryState = ref.watch(libraryProvider);

    return Scaffold(
      backgroundColor: t.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: t.background.withValues(alpha: 0.8),
            floating: true,
            title: Text(
              'Settings',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: t.textPrimary,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          SliverPadding(
            padding: EdgeInsets.only(
    left: 20,
    right: 20,
    bottom: MediaQuery.of(context).padding.bottom+100,
  ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                
                // Engagement Section
                const SettingsSectionHeader(title: 'Engagement'),
                const SizedBox(height: 8),
                EngagementCard(state: libraryState),
                const SizedBox(height: 24),
                
                // Appearance Section
                const SettingsSectionHeader(title: 'Appearance'),
                const SizedBox(height: 8),
                SettingsCard(
                  padding: const EdgeInsets.all(16),
                  child: const ThemeSelector(),
                ),
                const SizedBox(height: 24),
                
                // Notifications Section
                const SettingsSectionHeader(title: 'Notifications'),
                const SizedBox(height: 8),
                SettingsCard(
                  child: const NotificationSettings(),
                ),
                const SizedBox(height: 24),
                
                // Language Section
                const SettingsSectionHeader(title: 'Language'),
                const SizedBox(height: 8),
                SettingsCard(
                  child: const LanguageToggle(),
                ),
                const SizedBox(height: 24),
                
                // Support Section
                const SettingsSectionHeader(title: 'Support'),
                const SizedBox(height: 8),
                SettingsCard(
                  child: const SupportSection(),
                ),
                const SizedBox(height: 48),
                
                // About Section
                const AboutSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}