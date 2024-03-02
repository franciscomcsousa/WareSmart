from flask import Flask, render_template, make_response
from flask import json
import random

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/sensors')
def sensors():
    # Humidity, Temperature and Light
    data = {
        'temperature': random.randint(1, 100),
        'humidity': random.randint(1, 100),
        'light': random.randint(1, 100)
    }   
    response = app.response_class(
        response = json.dumps(data),
        status = 200,
        mimetype = 'application/json'
    )
    return response


if __name__ == '__main__':
    app.run(host='127.0.0.1', debug=True)