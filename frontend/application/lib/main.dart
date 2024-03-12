import 'package:flutter/material.dart';
import 'httpRequests.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  late Future<Sensors> futureSensor = fetchSensors();

  @override
  Widget build(BuildContext context) {
    print("Built!");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Warehouse Monitoring'),
        ),
        body: ListViewHome(),
      ),
    );
  }
}

class ListViewHome extends StatelessWidget {
  ListViewHome({super.key});

  final titles = ["Humidity", "Temperature", "Light"];

  final subtitles = [
    "Percentage of humidity",
    "Temperature in Celsius degrees",
    "Light level in lumens"
  ];

  final icons = [Icons.water_drop, Icons.thermostat, Icons.light];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      itemCount: titles.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // Probably insert future builder here
            print("Button tapped");
          },
          child: Container(
            height: 200,
            child: Card(
              child: Center(
                child: ListTile(
                  title: Text(titles[index]),
                  subtitle: Text(subtitles[index], textAlign: TextAlign.left),
                  trailing: Icon(icons[index]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
