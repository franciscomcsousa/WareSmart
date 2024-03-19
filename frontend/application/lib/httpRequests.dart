import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Sensors> fetchSensors() async {
  final response = await http
      .get(Uri.parse('http://127.0.0.1:5000/sensors'));


  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Sensors.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to read sensors');
  }
}

Future<void> toggleBLE() async {
  final url = Uri.parse('http://127.0.0.1:5000/toggleBLE');
  final headers = {'Content-Type': 'application/json'};

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    print('ToggleBLE success!');
  } else {
    print('Failed to toggle BLE: ${response.statusCode}');
  }
}

Future<void> toggleMovement() async {
  final url = Uri.parse('http://127.0.0.1:5000/toggleMovement');
  final headers = {'Content-Type': 'application/json'};

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    print('Toggle movement success!');
  } else {
    print('Failed to toggle movement: ${response.statusCode}');
  }
}



class Sensors {
  final int temperature;
  final int humidity;
  final int light;
  final bool movement;

  const Sensors({
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.movement
  });

  factory Sensors.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'temperature': int temperature,
        'humidity': int humidity,
        'light': int light,
        'movement': bool movement,
      } =>
        Sensors(
          temperature: temperature,
          humidity: humidity,
          light: light,
          movement: movement
        ),
      _ => throw const FormatException('Failed to read sensors.'),
    };
  }
}