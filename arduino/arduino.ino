#include <dht.h>
#include <Wire.h>

// Section related with the temperature sensor
const int dhtPin = 7;
dht DHT;

// Section related with the movement sensor
const int  movementPin = 8;
bool movement = false;

// Section related with the light sensor
int lightSensor = 0;
int lightMapped = 0;
int lightPin = 6;

// Minimum and maximum values for the light
// Value Max corresponds to the sensor value when close to a ceiling lamp
// Value Min corresponds to the sensor value when completely covered
int lightMin = 1;
int lightMax = 900;

int x = 0;

void setup() {
  pinMode(dhtPin, INPUT);
  pinMode(lightPin, INPUT);
  pinMode(movementPin, INPUT);
  Serial.begin(9600);
  Serial.setTimeout(1); 
}


void loop() {
  while (!Serial.available())
  {
    if(digitalRead(movementPin) == HIGH)
      movement = true;
  } 
  x = Serial.readString().toInt(); 
  if (x == 1) 
  {
    printTemp();
    printLight();
    if(movement)
    {
      Serial.println("M 1");
      movement = false;
    }
    else
      Serial.println("M 0");
  }
}

void printLight()
{
  lightSensor = analogRead(lightPin);
  lightMapped = map(lightSensor, lightMin, lightMax, 0, 100);
  Serial.print("L ");
  lightMapped = 50;
  Serial.println(lightMapped);
}

void printTemp()
{
  int chk = DHT.read11(dhtPin);
  Serial.print("T ");
  Serial.println(DHT.temperature);
  Serial.print("H ");
  Serial.println(DHT.humidity);
}
