from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/')
def hello():
    return 'Hello, World!'

@app.route('/alex')
def alex():
    return 'Hello, Alex!'

@app.route('/nmap/<ip>')
def nmap(ip):
    # TODO: run nmap and return the results
    devices = []
    # populate devices
    
    return {'ip': ip, 'devices': devices}