import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static final instance = LocalNotification._();
  LocalNotification._();

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var isFlutterLocalNotificationsInitialized = false;

  final _channel = const AndroidNotificationChannel(
    'notification_id',
    'notification',
    description: 'jify_notification_description',
    importance: Importance.max,
  );

  // Initial method which initialize local notification with appropriate settings
  Future<void> init() async {
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _onSelectNotification,
    );
    await _setupFlutterNotifications();
  }

  // Helps in setting up local notification channel
  Future<void> _setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  // Shows notification taken from remote message
  void showNotification(RemoteMessage message) async {
    final androidPlatformChannelSpecifics =
        await _getAndroidNotificationDetails(message: message);

    final iOSPlatformChannelSpecifics =
        await _getIosNotificationDetails(message: message);

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond,
        message.data["title"],
        message.data["body"],
        platformChannelSpecifics,
        payload: jsonEncode(message.data),
      );
    } catch (e) {}
  }

  Future<DarwinNotificationDetails> _getIosNotificationDetails({
    required RemoteMessage message,
  }) async {
    final appleMessage = message.notification?.apple;
    String? iconPath;

    return DarwinNotificationDetails(
      subtitle: appleMessage?.subtitle,
      attachments:
          iconPath == null ? null : [DarwinNotificationAttachment(iconPath)],
    );
  }

  Future<AndroidNotificationDetails> _getAndroidNotificationDetails({
    required RemoteMessage message,
  }) async {
    final androidMessage = message.notification?.android;
    String? iconPath;

    return AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      fullScreenIntent: true,
      priority: Priority.high,
      icon: androidMessage?.smallIcon ?? 'mipmap/ic_launcher',
      largeIcon: iconPath == null ? null : FilePathAndroidBitmap(iconPath),
      styleInformation: iconPath == null
          ? null
          : BigPictureStyleInformation(
              FilePathAndroidBitmap(iconPath),
              hideExpandedLargeIcon: true,
            ),
    );
  }

  void _onSelectNotification(NotificationResponse action) async {
    if (action.payload == null) {
      return;
    }
  }
}
