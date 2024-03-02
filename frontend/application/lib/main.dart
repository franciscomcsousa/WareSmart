import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
          onTap: () => print("Pressed " + titles[index]),
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
