import 'dart:async';

import 'package:application/httpRequests.dart';
import 'package:application/utilities.dart';
import 'package:flutter/material.dart';

class ViewHome extends StatefulWidget {
  final ValueNotifier<bool> isBLEEnabled, isMovementEnabled;
   final Limit limitValues;

  const ViewHome({Key? key, required this.isBLEEnabled, required this.isMovementEnabled, required this.limitValues}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListViewState();
}

class _ListViewState extends State<ViewHome> {
  Limit _limitValues = Limit(minTemp: 0, maxTemp: 50, minHum: 0, maxHum: 80);
  
  @override
  void initState() {
    
    // get current max/min values
    _limitValues = widget.limitValues;

    Timer? _timer;
    // Fetching all sensors data every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      final sensors = await fetchSensors();
      setState(() => verifyFetchedValues(sensors, _limitValues));
    });
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