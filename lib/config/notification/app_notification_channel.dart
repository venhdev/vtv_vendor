import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotificationChannels {
  /// Default Channel
  static const NotificationDetails defaultImportanceChannel = NotificationDetails(
    android: AndroidNotificationDetails(
      'default_importance_channel',
      'Default Notification Channel',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      sound: RawResourceAndroidNotificationSound('notification'),
    ),
  );

  /// High Importance Channel
  static const NotificationDetails highImportanceChannel = NotificationDetails(
    android: AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notification Channel',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification'),
    ),
  );
}
