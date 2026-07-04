// features/settings/screens/settings_screen.dart
//
// Clean replacement — no direct Navigator or legacy imports.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tibeb/shared/services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/theme.dart';
import '../../../features/library/providers/library_provider.dart';
import '../../../components/glass_container.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(libraryNotifierProvider);
    final notifier = ref.read(libraryNotifierProvider.notifier);
    final t = context.tibpiColors;

    return Scaffold(
      backgroundColor: t.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: t.background.withValues(alpha: 0.8),
            floating: true,
            title: Text('Settings',
                style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: t.textPrimary)),
            centerTitle: true,
            elevation: 0,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              _SectionHeader(label: 'Engagement'),
              _EngagementCard(state: state),
              const SizedBox(height: 24),
              _SectionHeader(label: 'Notifications'),
              _NotificationCard(state: state, notifier: notifier),
              const SizedBox(height: 24),
              _SectionHeader(label: 'Appearance'),
              _ThemeCard(ref: ref),
              const SizedBox(height: 48),
              _SectionHeader(label: 'More'),
              _MoreCard(),
              const SizedBox(height: 48),
              _AboutSection(),
              const SizedBox(height: 120),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─── Section header ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
            color: t.primary.withValues(alpha: 0.8),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2),
      ),
    );
  }
}

// ─── Engagement Card ─────────────────────────────────────────────────────────

class _EngagementCard extends StatelessWidget {
  final LibraryState state;
  const _EngagementCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: t.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle),
            child: Icon(Icons.stars_rounded, color: t.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Level ${state.level}',
                  style: TextStyle(
                      color: t.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text(state.rankName,
                  style: TextStyle(color: t.textSecondary, fontSize: 14)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${state.totalXP}',
                style: TextStyle(
                    color: t.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text('TOTAL XP',
                style: TextStyle(
                    color: t.textTertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ]),
        ]),
      ),
    );
  }
}

// ─── Notification Card ───────────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final LibraryState state;
  final LibraryNotifier notifier;
  const _NotificationCard(
      {required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassContainer(
        child: Column(children: [
          SwitchListTile(
            value: state.notificationsEnabled,
            onChanged: (v) =>
                notifier.updateNotificationSettings(enabled: v),
            title: Text('Daily Reminders',
                style: TextStyle(color: t.textPrimary)),
            subtitle: Text('Keep your reading streak alive',
                style: TextStyle(color: t.textSecondary)),
            activeThumbColor: t.primary,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          if (state.notificationsEnabled)
            ListTile(
              title: Text('Reminder Time',
                  style: TextStyle(color: t.textPrimary)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(
                    '${state.reminderHour.toString().padLeft(2, '0')}:${state.reminderMinute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                        color: t.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: t.borderSubtle),
              ]),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                      hour: state.reminderHour,
                      minute: state.reminderMinute),
                  builder: (ctx, child) => Theme(
                    data: Theme.of(ctx).copyWith(
                        colorScheme: ColorScheme.dark(
                            primary: t.primary,
                            onPrimary: t.textOnPrimary,
                            surface: t.surface,
                            onSurface: t.textPrimary)),
                    child: child!,
                  ),
                );
                if (time != null) {
                  notifier.updateNotificationSettings(
                      hour: time.hour, minute: time.minute);
                }
              },
            ),
          Divider(color: t.borderSubtle, height: 1),
          ListTile(
            leading:
                Icon(Icons.notification_important_rounded, color: t.primary),
            title: Text('Test Notification',
                style: TextStyle(color: t.textPrimary)),
            subtitle: Text('Verify reminders work.',
                style: TextStyle(color: t.textSecondary, fontSize: 12)),
            trailing: Icon(Icons.send_rounded, color: t.primary, size: 20),
            onTap: () => _testNotification(context, t),
          ),
        ]),
      ),
    );
  }

  Future<void> _testNotification(
      BuildContext context, TibebThemeExtension t) async {
    final status = await Permission.notification.status;
    if (status.isPermanentlyDenied) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: t.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Notifications Blocked',
              style: TextStyle(
                  color: t.textPrimary, fontWeight: FontWeight.bold)),
          content: Text(
              'Reading reminders are blocked. Enable them in settings!',
              style: TextStyle(color: t.textSecondary)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Maybe Later',
                    style: TextStyle(color: t.textTertiary))),
            TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                },
                child: Text('Open Settings',
                    style: TextStyle(
                        color: t.primary, fontWeight: FontWeight.bold))),
          ],
        ),
      );
      return;
    }
    final granted = await NotificationService().requestPermissions();
    if (granted) {
      await NotificationService().showNotification(
          id: 888,
          title: 'Test Notification 📚',
          body: 'Reminders are working! Happy reading.');
    }
  }
}

// ─── Theme Card ───────────────────────────────────────────────────────────────

class _ThemeCard extends ConsumerWidget {
  final WidgetRef ref;
  const _ThemeCard({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef watchRef) {
    final t = context.tibpiColors;
    final current = watchRef.watch(themeModeProvider);
    final themes = [
      (ThemeMode.light, 'Light', Icons.light_mode_rounded,
          const Color(0xFFFDFBF7)),
      (ThemeMode.dark, 'Dark', Icons.dark_mode_rounded, Colors.black),
      (ThemeMode.system, 'System', Icons.settings_suggest_rounded, null),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: themes.map((item) {
          final (mode, label, icon, color) = item;
          final selected = current == mode;
          return Expanded(
            child: GestureDetector(
              onTap: () =>
                  watchRef.read(themeModeProvider.notifier).setThemeMode(mode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: selected
                      ? t.primary.withValues(alpha: 0.08)
                      : t.surface.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: selected ? t.primary : t.borderSubtle,
                      width: selected ? 2 : 1),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: t.border.withValues(alpha: 0.2)),
                    ),
                    child: mode == ThemeMode.system
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Row(children: [
                              Expanded(
                                  child: Container(
                                      color: const Color(0xFFFDFBF7))),
                              Expanded(
                                  child: Container(color: Colors.black)),
                            ]))
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(icon,
                        size: 15,
                        color: selected ? t.primary : t.textSecondary),
                    const SizedBox(width: 5),
                    Text(label,
                        style: TextStyle(
                            color:
                                selected ? t.textPrimary : t.textSecondary,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13)),
                  ]),
                ]),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── More Card ────────────────────────────────────────────────────────────────

class _MoreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassContainer(
        child: Column(children: [
          _LinkTile(
            t: t,
            icon: Icons.volunteer_activism_rounded,
            title: 'Support the Developer',
            subtitle: 'Support Samuel and the project ❤️',
            url: 'https://www.gurshaplus.com/samkiyya',
          ),
          Divider(color: t.borderSubtle, height: 1),
          _LinkTile(
            t: t,
            icon: Icons.code_rounded,
            title: 'Contribute on GitHub',
            subtitle: 'Help build the future of Tibeb 🚀',
            url: 'https://github.com/samkiyya/tibeb',
          ),
        ]),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final TibebThemeExtension t;
  final IconData icon;
  final String title;
  final String subtitle;
  final String url;

  const _LinkTile({
    required this.t,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: t.primary),
      title: Text(title,
          style: TextStyle(
              color: t.textPrimary, fontWeight: FontWeight.bold)),
      subtitle:
          Text(subtitle, style: TextStyle(color: t.textSecondary, fontSize: 12)),
      trailing: Icon(Icons.open_in_new_rounded,
          color: t.textTertiary, size: 20),
      onTap: () async {
        try {
          await launchUrl(Uri.parse(url),
              mode: LaunchMode.externalApplication);
        } catch (_) {}
      },
    );
  }
}

// ─── About Section ───────────────────────────────────────────────────────────

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return Center(
      child: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (ctx, snap) {
          final version = snap.hasData
              ? 'v${snap.data!.version}+${snap.data!.buildNumber}'
              : '...';
          return Text('Tibeb $version',
              style: TextStyle(
                  color: t.textSecondary.withValues(alpha: 0.5),
                  fontSize: 12));
        },
      ),
    );
  }
}
