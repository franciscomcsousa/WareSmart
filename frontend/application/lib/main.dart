import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:application/notificationController.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'httpRequests.dart';

void main() async {
  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: "movement_alert",
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

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Warehouse Monitoring'),
        ),
        body: ListViewHome(isBLEEnabled: _isBLEEnabled, isMovementEnabled: _isMovementEnabled),
        drawer: NavigationDrawer(isBLEEnabled: _isBLEEnabled, isMovementEnabled: _isMovementEnabled),
      ),
    );
  }
}

class NavigationDrawer extends StatefulWidget {
  final ValueNotifier<bool> isBLEEnabled, isMovementEnabled;

  const NavigationDrawer({Key? key, required this.isBLEEnabled, required this.isMovementEnabled}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  bool _isBLEEnabled = false, _isMovementEnabled = true; // Local state copy

  @override
  void initState() {
    super.initState();
    // get current values
    _isBLEEnabled = widget.isBLEEnabled.value;
    _isMovementEnabled = widget.isMovementEnabled.value;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              title: const Text('BLE proximity'),
              value: _isBLEEnabled,
              // update switch values
              onChanged: (value) => setState(() {
                _isBLEEnabled = value;
                toggleBLE();
              }
              ),
            ),
            SwitchListTile(
              title: const Text('Movement detection'),
              value: _isMovementEnabled,
              onChanged: (value) => setState(() {
                _isMovementEnabled = value;
                toggleMovement();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ListViewHome extends StatefulWidget {
  final ValueNotifier<bool> isBLEEnabled, isMovementEnabled;

  const ListViewHome({Key? key, required this.isBLEEnabled, required this.isMovementEnabled}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListViewState();
}

class _ListViewState extends State<ListViewHome> {
  @override
  void initState() {
    
    Timer? _timer;

    // Fetching sensors data every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      final sensors = await fetchSensors();
      setState(() {
        if (sensors.movement) {
          showMovementNotification();
        }
      });
    });
  }

  void showMovementNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "movement_alert",
        title: "ALERT, movement detected!",
        body: "Non-authorized movement has been detected in your storage room.",
      ),
    );
  }
  
  final titles = ["Humidity", "Temperature", "Light"];

  final subtitles = [
    "Percentage of humidity",
    "Temperature in Celsius degrees",
    "Light level in lumens"
  ];

  final units = ["%", "°C", "lm"];

  final reading = ["...", "...", "..."];

  final icons = [Icons.water_drop, Icons.thermostat, Icons.light];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      itemCount: titles.length,
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: fetchSensors(),
          builder: (context, snapshot) {
            return InkWell(
              // TODO - try using doubleTap and tripleTap to add a forced cooldown between taps
              onTap: () {
                // setState triggers a state update
                setState(
                  () {
                    if (snapshot.hasData) {
                      var snapshotList = [
                        snapshot.data!.humidity,
                        snapshot.data!.temperature,
                        snapshot.data!.light,
                      ];
                      reading[index] = snapshotList[index].toString();
                    } else if (snapshot.hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          // TODO - add action to retry
                          content: Text(
                              "Couldn't obtain data for the ${titles[index].toLowerCase()} value. Please try again later."),
                        ),
                      );
                    }
                    print("Fetched ${reading[index]} ${units[index]}.");
                  },
                );
              },
              child: Container(
                height: 200,
                child: Card(
                  child: Center(
                    child: ListTile(
                      title: Text(
                        "${titles[index]}",
                        style: const TextStyle(fontSize: 20.00),
                      ),
                      subtitle:
                          Text(subtitles[index], textAlign: TextAlign.left),
                      leading: Icon(
                        icons[index],
                        size: 40,
                      ),
                      trailing: Text("${reading[index]} ${units[index]}",
                          style: const TextStyle(fontSize: 35.0)),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  
}
