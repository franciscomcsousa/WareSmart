from flask import Flask, render_template, make_response, request
from flask import json
import random
import sys

homeDir = "/home/framboesa/SmartStorage/AmbientIntelligence/backend/"

# Import communication package
sys.path.insert(0, f"{homeDir}communication")
# Import bluetooth package
sys.path.insert(0, f"{homeDir}bluetooth")

from serialCommunication import fetchSensors
from checkProximity import is_device_near

# flag for movement toggle
runMovement = False

runProximity = False

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/toggleBLE', methods=['POST'])
def toggleBLE():
    if request.method != 'POST':
        return
    global runProximity
    data = request.get_json()
    runProximity = data.get('value')
    print(f"Toggle Proximity: {runProximity}")
    response = app.response_class(
        status = 200,
        mimetype = 'application/json'
    )
    return response

@app.route('/toggleMovement', methods=['POST'])
def toggleMovement():
    if request.method != 'POST':
        return
    global runMovement
    data = request.get_json()
    runMovement = data.get('value')
    print(f"Toggle Movement: {runMovement}")
    response = app.response_class(
        status = 200,
        mimetype = 'application/json'
    )
    return response

@app.route('/sensors')
def sensors():
    sensors = fetchSensors()
    global runMovement
    global runProximity

    nearby = False
    # Check if someone is near the device
    if (runProximity):
        nearby = is_device_near()
    if (nearby):
        print("Movement detected, however device is nearby, aborting alert...")
    # Humidity, Temperature and Light
    data = {
        'temperature': sensors["temperature"],
        'humidity': sensors["humidity"],
        'light': sensors["light"],
        'movement': False if ((not runMovement) or nearby) else sensors["movement"]
    }   
    response = app.response_class(
        response = json.dumps(data),
        status = 200,
        mimetype = 'application/json'
    )
    return response

if __name__ == '__main__':
    app.run(host='127.0.0.1', debug=True)