import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  LocalNotification._();
  static final LocalNotification instance = LocalNotification._();
  Function(String) onSelectNotification;
  Function(int id, String title, String body, String payload)
      didReceiveLocalNotification;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  Future init() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    if (didReceiveLocalNotification != null)
      didReceiveLocalNotification(id, title, body, payload);
  }

  Future selectNotification(String payload) async {
    if (onSelectNotification != null) onSelectNotification(payload);
  }

  Future sendNotification(String title, String body,
      {int id = 0, String payload = ''}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1128', 'flutterNotification', 'for local Notification',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentAlert: true, presentBadge: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin
        .show(id, title, body, platformChannelSpecifics, payload: payload);
  }
}
