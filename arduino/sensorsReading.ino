#include <dht.h>
#include <Wire.h>

// Sample rate for each of the sensors
unsigned int printRate = 5000;

// Section related with the temperature sensor
unsigned long int tempTime = 0;
unsigned int dhtPin = 7;
dht DHT;

// Section related with the light sensor
int lightSensor = 0;
int lightMapped = 0;
int lightPin = 6;
unsigned long int lightTime = 0;

// Minimum and maximum values for the light
// Value Max corresponds to the sensor value when close to a ceiling lamp
// Value Min corresponds to the sensor value when completely covered
int lightMin = 1;
int lightMax = 900;

void setup() {
  pinMode(dhtPin, INPUT);
  pinMode(lightPin, INPUT);
}


void loop() {
  printLight();
  printTemp();
}

void printLight()
{
  if (millis() < lightTime + printRate)
    return;
  lightTime = millis();
  lightSensor = analogRead(lightPin);
  lightMapped = map(lightSensor, lightMin, lightMax, 0, 255);
  //Serial.println(lightMapped);
}

void printTemp()
{
  if (millis() < tempTime + printRate)
    return;
  Serial.begin(9600);
  tempTime = millis();
  int chk = DHT.read11(dhtPin);
  Serial.print("T ");
  Serial.println(DHT.temperature);
  Serial.print("H ");
  Serial.println(DHT.humidity);
  Serial.end();
}
