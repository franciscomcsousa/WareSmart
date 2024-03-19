import 'package:application/utilities.dart';
import 'package:application/view.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:application/drawer.dart';

void main() async {
  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: "alert",
          channelName: "Alert",
          channelDescription: "Suspicious movement detected!",
          channelGroupKey: "alert_group",
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: "alert_group", channelGroupName: "Alert Group")
      ],
      debug: true);

  bool isNotificationsAllowed =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isNotificationsAllowed) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // initial toggle states, BLE and Movement
    final _isBLEEnabled = ValueNotifier<bool>(false);
    final _isMovementEnabled = ValueNotifier(true);
    const Limit _limitValues = Limit(minTemp: 0, maxTemp: 50, minHum: 0, maxHum: 80);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Warehouse Monitoring'),
        ),
        body: ViewHome(isBLEEnabled: _isBLEEnabled, isMovementEnabled: _isMovementEnabled, limitValues: _limitValues),
        drawer: NavDrawer(isBLEEnabled: _isBLEEnabled, isMovementEnabled: _isMovementEnabled, limitValues: _limitValues),
      ),
    );
  }
}