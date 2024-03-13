# Importing Libraries 
import serial 
import time 

arduino = serial.Serial(port='/dev/ttyACM0', baudrate=9600, timeout=.1)

def fetchSensors():

	humidity = -1
	temperature = -1

	while (True):
		arduino.write(bytes("1", 'utf-8'))
		value = arduino.readline().decode()
		parameters = value.split()

		if (len(parameters) > 0):
			sensorValue = int(float(parameters[1]))
			if parameters[0] == "T":
				print(f"Temperature is {sensorValue}")
				temperature = sensorValue
			elif parameters[0] == "H":
				print(f"Humidity is {sensorValue}")
				humidity = sensorValue
			if (humidity != -1 and temperature != -1):
				# Clean excessive requests
				trash = arduino.readall().decode()
				lastFetch = int(time.time())
				break

	return {"temperature": temperature, "humidity": humidity}

fetchSensors()