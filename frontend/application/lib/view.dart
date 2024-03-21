import 'dart:async';

import 'package:application/drawer.dart';
import 'package:application/httpRequests.dart';
import 'package:application/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewHome extends StatefulWidget {

  const ViewHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListViewState();
}

class _ListViewState extends State<ViewHome> {
  
  Timer? _timer;

  var alertsPresent = [false, false, false];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      print("ALERTS PRESENT: ${alertsPresent}");
      final sensors = await fetchSensors();
      setState(() {
        // no need to listen in the viewHome, because it only changes in the Drawer
        final objectPresentState = Provider.of<ObjectPresentState>(context, listen: false); 
        alertsPresent = verifyFetchedValues(sensors, objectPresentState.limitValues, alertsPresent);
      });
    });
    final timer = Timer.periodic(const Duration(seconds: 20), (timer) async {
      alertsPresent[0] = alertsPresent[1] = alertsPresent[2] = false;
    });
  }
  
  final titles = ["Humidity", "Temperature", "Light"];

  final subtitles = [
    "Percentage of humidity",
    "Temperature in Celsius degrees",
    "Light level in relative percentage"
  ];

  final units = ["%", "°C", "%"];

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