import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/theme/theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/settings_provider.dart';
import '../../providers/library_provider.dart';
import '../../services/notification_service.dart';
import '../../l10n/app_localizations.dart';

class NotificationSettings extends ConsumerWidget {
  const NotificationSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;
    final state = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        SwitchListTile(
          value: state.notificationsEnabled,
          onChanged: (val) {
            // Update both settings provider and library provider
            ref.read(settingsProvider.notifier).updateNotificationSettings(enabled: val);
            ref.read(libraryProvider.notifier).updateNotificationSettings(enabled: val);
          },
          title: Text(
            l10n.dailyReminders,
            style: TextStyle(color: t.textPrimary),
          ),
          subtitle: Text(
            l10n.keepReadingStreakAlive,
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
              l10n.reminderTime,
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
                // Update both settings provider and library provider
                ref.read(settingsProvider.notifier).updateNotificationSettings(
                  hour: time.hour,
                  minute: time.minute,
                );
                ref.read(libraryProvider.notifier).updateNotificationSettings(
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
            l10n.testNotification,
            style: TextStyle(color: t.textPrimary),
          ),
          subtitle: Text(
            l10n.receiveTestAlert,
            style: TextStyle(color: t.textSecondary, fontSize: 12),
          ),
          trailing: Icon(Icons.send_rounded, color: t.primary, size: 20),
          onTap: () => _sendTestNotification(context, ref, t, l10n),
        ),
      ],
    );
  }

  Future<void> _sendTestNotification(
    BuildContext context,
    WidgetRef ref,
    TibebThemeExtension t,
    AppLocalizations l10n,
  ) async {
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
                    l10n.notificationsBlocked,
                    style: TextStyle(
                      color: t.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    l10n.notificationsBlockedMessage,
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
                        openAppSettings();
                        Navigator.pop(context);
                      },
                      child: Text(
                        l10n.openSettings,
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

    final granted = await NotificationService().requestPermissions();
    if (granted) {
      await NotificationService().showNotification(
        id: AppConstants.testNotificationId,
        title: 'Test Notification 📚',
        body: "Reminders are working correctly! Happy reading.",
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.notificationPermissionsRequired,
            style: TextStyle(color: t.textPrimary),
          ),
          backgroundColor: t.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}