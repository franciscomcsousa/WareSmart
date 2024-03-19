from flask import Flask, render_template, make_response
from flask import json
import threading
import random
import time
import sys

# Import communication package
sys.path.insert(0, '../../communication')

# flag for movement toggle
ignoreMovement = False

#from serialCommunication import fetchSensors
app = Flask(__name__)

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/toggleBLE')
def toggle():
    global ignoreMovement
    ignoreMovement = not ignoreMovement
    print(ignoreMovement)
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
    data = {
        'temperature': random.randint(-20, 60),
        'humidity': random.randint(1, 100),
        'light': random.randint(150, 3500),
        'movement': False if ignoreMovement else random.random() < 0.30
    }   
    response = app.response_class(
        response = json.dumps(data),
        status = 200,
        mimetype = 'application/json'
    )
    return response

if __name__ == '__main__':
    app.run(host='127.0.0.1', debug=True)