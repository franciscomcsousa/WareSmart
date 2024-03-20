from flask import Flask, render_template, make_response, request
from flask import json
import threading
import random
import time
import sys

homeDir = "/home/framboesa/SmartStorage/AmbientIntelligence/backend/"

# Import communication package
sys.path.insert(0, f"{homeDir}communication")
# Import bluetooth package
sys.path.insert(0, f"{homeDir}bluetooth")

from checkProximity import is_device_near

# flag for movement toggle
runMovement = False

runProximity = False

#from serialCommunication import fetchSensors
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
    response = app.response_class(
        status = 200,
        mimetype = 'application/json'
    )
    return response

@app.route('/sensors')
def sensors():
    #sensors = fetchSensors()
    # Humidity, Temperature and Light
    print("Sensor request")
    global runMovement
    global runProximity

    nearby = False
    if (runProximity):
        nearby = is_device_near()
        
    data = {
        'temperature': random.randint(-20, 60),
        'humidity': random.randint(1, 100),
        'light': random.randint(150, 3500),
        'movement': False if ((not runMovement) or nearby) else random.random() < 0.30
    }   
    response = app.response_class(
        response = json.dumps(data),
        status = 200,
        mimetype = 'application/json'
    )
    return response

if __name__ == '__main__':
    app.run(host='127.0.0.1', debug=True)