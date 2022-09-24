import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  static NotificationManager _instance;

  FlutterLocalNotificationsPlugin flutterNotification;
  BuildContext context;

  NotificationManager._(BuildContext context) {
    this.context = context;
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    flutterNotification = new FlutterLocalNotificationsPlugin();
    flutterNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  factory NotificationManager.instance(BuildContext context) {
    if (_instance == null) {
      _instance = NotificationManager._(context);
    }
    return _instance;
  }

  Future showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.Max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iSODetails);

    await flutterNotification.show(
        0, "Task", "You created a Task", generalNotificationDetails,
        payload: "Task");
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

}
