import '../../services/notification_service.dart';

class DeferredNotification {
  final String title;
  final String body;
  final int id;

  DeferredNotification({
    required this.title,
    required this.body,
    required this.id,
  });
}

class ReadingNotificationManager {
  static List<DeferredNotification> showOrDefer({
    required bool isReading,
    required List<DeferredNotification> existing,
    required int id,
    required String title,
    required String body,
  }) {
    if (!isReading) {
      NotificationService().showNotification(
        id: id,
        title: title,
        body: body,
      );
      return existing;
    } else {
      return [
        ...existing,
        DeferredNotification(id: id, title: title, body: body),
      ];
    }
  }

  static Future<void> processDeferredNotifications(
    List<DeferredNotification> notifications,
  ) async {
    for (var i = 0; i < notifications.length; i++) {
      final dn = notifications[i];
      await Future.delayed(Duration(milliseconds: i * 1500));
      NotificationService().showNotification(
        id: dn.id,
        title: dn.title,
        body: dn.body,
      );
    }
  }
}
