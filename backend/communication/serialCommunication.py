# Importing Libraries 
import serial 
import time 

temperature = -1
humidity = -1

arduino = serial.Serial(port='/dev/ttyACM0', baudrate=9600, timeout=.1) 
def arduino_read(): 
	data = arduino.readline().decode()
	return data

def fetchSensors():
	return {"temperature": temperature, "humidity": humidity}

while True: 
	value = arduino_read()
	parameters = value.split()
	if (len(parameters) > 0):
		sensorValue = int(float(parameters[1]))
		if parameters[0] == "T":
			print(f"Temperature is {sensorValue}")
			temperature = sensorValue
		elif parameters[0] == "H":
			print(f"Humidity is {sensorValue}")
			humidity = sensorValue
	time.sleep(1)

