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
    Limit _limitValues = Limit(minTemp: 0, maxTemp: 50, minHum: 0, maxHum: 80);
  
  @override
  void initState() {
    Timer? _timer;
    // Fetching all sensors data every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final sensors = await fetchSensors();
      setState(() => verifyFetchedValues(sensors, _limitValues));
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
    //final ObjectPresentState _isObjectPresentState = Provider.of<ObjectPresentState>(context);

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