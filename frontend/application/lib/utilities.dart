import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

class Limit {
  final int minTemp;
  final int maxTemp;
  final int minHum;
  final int maxHum;

  const Limit({
    required this.minTemp,
    required this.maxTemp,
    required this.minHum,
    required this.maxHum,
  });
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

Limit getNewLimit(Limit limit1, Limit limit2) {
  return Limit(
    minTemp: max(limit1.minTemp, limit2.minTemp),
    maxTemp: min(limit1.maxTemp, limit2.maxTemp),
    minHum: max(limit1.minHum, limit2.minHum),
    maxHum: min(limit1.maxHum, limit2.maxHum),
  );
}

void verifyFetchedValues(Sensors sensors, Limit limitValues) {

  if (sensors.temperature < limitValues.minTemp || sensors.temperature > limitValues.maxTemp) {
    showNotification("temperature", 1);
  }
  if (sensors.humidity < limitValues.minHum || sensors.humidity > limitValues.maxHum) {
    showNotification("humidity", 2);
  }
  if (sensors.movement) {
    showNotification("movement", 3);
  }   
}

void showNotification(String alertType, int _id) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _id,
        channelKey: "alert",
        title: "ALERT, ${alertType}!",
        body: "There could be a problem with the ${alertType} sensor.",
      ),
    );
}