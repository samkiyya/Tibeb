import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/theme/theme.dart';
import '../providers/library_provider.dart';
import '../widgets/glass_container.dart';
import '../services/notification_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(libraryProvider);
    final notifier = ref.read(libraryProvider.notifier);
    final t = context.tibpiColors;

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
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              _buildSectionHeader(t, 'Engagement'),
              _buildEngagementCard(t, state),
              const SizedBox(height: 24),
              _buildSectionHeader(t, 'Notifications'),
              _buildNotificationToggles(context, t, state, notifier),
              const SizedBox(height: 24),
              _buildSectionHeader(t, 'Appearance'),
              _buildThemeCard(context, t, ref),
              const SizedBox(height: 48),
              _buildSectionHeader(t, 'More'),
              _buildMoreCard(t),
              const SizedBox(height: 48),
              _buildAboutSection(t),
              const SizedBox(height: 120),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(TibebThemeExtension t, String title) {
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

  Widget _buildEngagementCard(TibebThemeExtension t, LibraryState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
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
                        'Level ${state.level}',
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
                      '${state.totalXP}',
                      style: TextStyle(
                        color: t.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'TOTAL XP',
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
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggles(
    BuildContext context,
    TibebThemeExtension t,
    LibraryState state,
    LibraryNotifier notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassContainer(
        child: Column(
          children: [
            SwitchListTile(
              value: state.notificationsEnabled,
              onChanged: (val) =>
                  notifier.updateNotificationSettings(enabled: val),
              title: Text(
                'Daily Reminders',
                style: TextStyle(color: t.textPrimary),
              ),
              subtitle: Text(
                'Keep your reading streak alive',
                style: TextStyle(color: t.textSecondary),
              ),
              activeThumbColor: t.primary,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            if (state.notificationsEnabled)
              ListTile(
                title: Text(
                  'Reminder Time',
                  style: TextStyle(color: t.textPrimary),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${state.reminderHour.toString().padLeft(2, '0')}:${state.reminderMinute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: t.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right_rounded, color: t.borderSubtle),
                  ],
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: state.reminderHour,
                      minute: state.reminderMinute,
                    ),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: t.primary,
                            onPrimary: t.textOnPrimary,
                            surface: t.surface,
                            onSurface: t.textPrimary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (time != null) {
                    notifier.updateNotificationSettings(
                      hour: time.hour,
                      minute: time.minute,
                    );
                  }
                },
              ),
            Divider(color: t.borderSubtle, height: 1),
            ListTile(
              leading: Icon(
                Icons.notification_important_rounded,
                color: t.primary,
              ),
              title: Text(
                'Test Notification',
                style: TextStyle(color: t.textPrimary),
              ),
              subtitle: Text(
                'Receive a test alert to verify reminders work.',
                style: TextStyle(color: t.textSecondary, fontSize: 12),
              ),
              trailing: Icon(Icons.send_rounded, color: t.primary, size: 20),
              onTap: () async {
                final status = await Permission.notification.status;

                if (status.isPermanentlyDenied) {
                  if (context.mounted) {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: '',
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, anim1, anim2) => const SizedBox(),
                      transitionBuilder: (context, anim1, anim2, child) {
                        return Transform.scale(
                          scale: anim1.value,
                          child: Opacity(
                            opacity: anim1.value,
                            child: AlertDialog(
                              backgroundColor: t.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Text(
                                'Notifications Blocked',
                                style: TextStyle(
                                  color: t.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'Reading reminders are currently blocked by your system settings. Please enable them to stay on track!',
                                style: TextStyle(color: t.textSecondary),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Maybe Later',
                                    style: TextStyle(color: t.textTertiary),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    openAppSettings();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Open Settings',
                                    style: TextStyle(
                                      color: t.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return;
                }

                final granted = await NotificationService()
                    .requestPermissions();
                if (granted) {
                  await NotificationService().showNotification(
                    id: 888,
                    title: 'Test Notification 📚',
                    body: "Reminders are working correctly! Happy reading.",
                  );
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Notification permissions are required for reminders.',
                        style: TextStyle(color: t.textPrimary),
                      ),
                      backgroundColor: t.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreCard(TibebThemeExtension t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassContainer(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.volunteer_activism_rounded, color: t.primary),
              title: Text(
                'Support the Developer AKA Samuel',
                style: TextStyle(
                  color: t.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Support the developer and the project ❤️',
                style: TextStyle(color: t.textSecondary, fontSize: 12),
              ),
              trailing: Icon(
                Icons.open_in_new_rounded,
                color: t.textTertiary,
                size: 20,
              ),
              onTap: () async {
                final uri = Uri.parse('https://www.gurshaplus.com/samkiyya');
                try {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } catch (e) {
                  debugPrint('Could not launch $uri: $e');
                }
              },
            ),
            Divider(color: t.borderSubtle, height: 1),
            ListTile(
              leading: Icon(Icons.code_rounded, color: t.primary),
              title: Text(
                'Contribute on GitHub',
                style: TextStyle(
                  color: t.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Help build the future of tibeb 🚀',
                style: TextStyle(color: t.textSecondary, fontSize: 12),
              ),
              trailing: Icon(
                Icons.open_in_new_rounded,
                color: t.textTertiary,
                size: 20,
              ),
              onTap: () async {
                final uri = Uri.parse('https://github.com/samkiyya/tibeb');
                try {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } catch (e) {
                  debugPrint('Could not launch $uri: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(TibebThemeExtension t) {
    return Center(
      child: Column(
        children: [
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.hasData
                  ? 'v${snapshot.data!.version}+${snapshot.data!.buildNumber}'
                  : '...';
              return Text(
                'tibeb $version',
                style: TextStyle(
                  color: t.textSecondary.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    TibebThemeExtension t,
    WidgetRef ref,
  ) {
    final currentThemeMode = ref.watch(themeModeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildThemeTile(
              context: context,
              t: t,
              ref: ref,
              title: 'Light',
              icon: Icons.light_mode_rounded,
              themeMode: ThemeMode.light,
              isSelected: currentThemeMode == ThemeMode.light,
              previewWidget: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFBF7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.08),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 30,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.brown.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildThemeTile(
              context: context,
              t: t,
              ref: ref,
              title: 'Dark',
              icon: Icons.dark_mode_rounded,
              themeMode: ThemeMode.dark,
              isSelected: currentThemeMode == ThemeMode.dark,
              previewWidget: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 30,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildThemeTile(
              context: context,
              t: t,
              ref: ref,
              title: 'System',
              icon: Icons.settings_suggest_rounded,
              themeMode: ThemeMode.system,
              isSelected: currentThemeMode == ThemeMode.system,
              previewWidget: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: t.border.withValues(alpha: 0.2)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(color: const Color(0xFFFDFBF7)),
                      ),
                      Expanded(child: Container(color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeTile({
    required BuildContext context,
    required TibebThemeExtension t,
    required WidgetRef ref,
    required String title,
    required IconData icon,
    required ThemeMode themeMode,
    required bool isSelected,
    required Widget previewWidget,
  }) {
    return GestureDetector(
      onTap: () {
        ref.read(themeModeProvider.notifier).setThemeMode(themeMode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? t.primary.withValues(alpha: 0.08)
              : t.surface.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? t.primary : t.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: t.primary.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            previewWidget,
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: isSelected ? t.primary : t.textSecondary,
                ),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? t.textPrimary : t.textSecondary,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
