from flask import Flask, render_template, make_response
from flask import json
import threading
import random
import time
import sys

# Import communication package
sys.path.insert(0, '../../communication')
# Import bluetooth package
sys.path.insert(0, '../../../bluetooth')

from checkProximity import is_device_near

# flag for movement toggle
ignoreMovement = False

runProximity = False

#from serialCommunication import fetchSensors
app = Flask(__name__)

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/toggleBLE')
def toggleBLE():
    global runProximity
    runProximity = not runProximity
    response = app.response_class(
        status = 200,
        mimetype = 'application/json'
    )
    return response

@app.route('/toggleMovement')
def toggleMovement():
    global ignoreMovement
    ignoreMovement = not ignoreMovement
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
    global ignoreMovement
    global runProximity

    nearby = False
    if (runProximity):
        nearby = is_device_near()

    data = {
        'temperature': random.randint(-20, 60),
        'humidity': random.randint(1, 100),
        'light': random.randint(150, 3500),
        'movement': False if (ignoreMovement or nearby) else random.random() < 0.30
    }   
    response = app.response_class(
        response = json.dumps(data),
        status = 200,
        mimetype = 'application/json'
    )
    return response

if __name__ == '__main__':
    app.run(host='127.0.0.1', debug=True)