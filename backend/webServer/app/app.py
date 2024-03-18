from flask import Flask, render_template, make_response
from flask import json
import random
import sys

# Import communication package
sys.path.insert(0, '../../communication')

from serialCommunication import fetchSensors

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/sensors')
def sensors():
    sensors = fetchSensors()
    # Humidity, Temperature and Light
    data = {
        'temperature': sensors["temperature"],
        'humidity': sensors["humidity"],
        'light': 25,
        'movement': sensors["movement"]
    }   
    response = app.response_class(
        response = json.dumps(data),
        status = 200,
        mimetype = 'application/json'
    )
    return response

if __name__ == '__main__':
    app.run(host='127.0.0.1', debug=True)