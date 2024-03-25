import 'dart:convert';

import 'package:application/utilities.dart';
import 'package:http/http.dart' as http;

const ip = "127.0.0.1:5000";

Future<Sensors> fetchSensors() async {
  final response = await http
      .get(Uri.parse('http://${ip}/sensors'));


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

Future<void> toggleBLE(bool isEnabled) async {
  final url = Uri.parse('http://${ip}/toggleBLE');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'value': isEnabled});

  final response = await http.post(url, headers: headers, body:body);

  if (response.statusCode == 200) {
    print('ToggleBLE success!');
  } else {
    print('Failed to toggle BLE: ${response.statusCode}');
  }
}

Future<void> toggleMovement(bool isEnabled) async {
  final url = Uri.parse('http://${ip}/toggleMovement');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'value': isEnabled});

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    print('Toggle movement success!');
  } else {
    print('Failed to toggle movement: ${response.statusCode}');
  }
}