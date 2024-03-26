# Importing Libraries 
import serial 
import time 

arduino = serial.Serial(port='/dev/ttyACM0', baudrate=9600, timeout=.1)

def fetchSensors():

	humidity = -1
	temperature = -1
	light = -1
	movement = -1

	print("--- Sensor read request ---")

	while (True):
		arduino.write(bytes("1", 'utf-8'))
		value = arduino.readline().decode()
		parameters = value.split()

		if (len(parameters) > 1):
			sensorValue = int(float(parameters[1]))
			if parameters[0] == "T":
				#print(f"Temperature is {sensorValue}")
				temperature = sensorValue
			elif parameters[0] == "H":
				#print(f"Humidity is {sensorValue}")
				humidity = sensorValue
			elif parameters[0] == "L":
				#print(f"Light is {sensorValue}")
				light = sensorValue
			elif parameters[0] == "M":
				movement = True if sensorValue == 1 else False
				#print(f"Movement? {movement}")

			if (humidity != -1 and temperature != -1 and movement != -1 and light != -1):
				# Clean excessive requests
				trash = arduino.readall().decode()
				lastFetch = int(time.time())
				break

	print(f" Temperature: {temperature}C Humidity: {humidity}% Light: {light}% Movement: {movement}")
	return {"temperature": temperature, "humidity": humidity, "light": light, "movement": movement}