import 'package:application/view.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:application/drawer.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BLEEnabledState()),
        ChangeNotifierProvider(create: (_) => MovementState()),
        ChangeNotifierProvider(create: (_) => ObjectPresentState()),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Warehouse Monitoring'),
          ),
          body: const ViewHome(),
          drawer: const NavDrawer(),
        ),
      )
    );
  }
}