from flask import Flask
from flask_cors import CORS
import psycopg2
import nmap
import socket

app = Flask(__name__)
CORS(app)


@app.route('/')
def hello():
    return 'Hello, World!'


@app.route('/alex')
def alex():
    return 'Hello, Alex!'


@app.route('/nmap')
def deviceInfo():
    hostname = socket.gethostname()
    IPAddr = socket.gethostbyname(hostname)
    # TODO: run nmap and return the results
    devices = []
    # populate devices
    print("Ip address for ", hostname, "is", IPAddr)
    nm = nmap.PortScanner()
    devices = nm.scan(hosts=IPAddr + '/24',
                      arguments="-sV -O -T4 -n -Pn -p 80,443 --max-rtt-timeout 100ms")
    print(devices)
    return {'devices': devices}
