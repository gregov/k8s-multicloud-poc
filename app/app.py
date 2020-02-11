from flask import Flask
from flask import request
from flask import jsonify
from pprint import pprint
import os
import json
import socket


app = Flask(__name__)

statefile = "/data/data.json"

@app.route('/')
def home():
    pprint(os.environ)
    remote_ip = request.remote_addr
    if os.path.exists(statefile):
        with open(statefile, "r") as f:
            history = json.load(f)
    else:
        history = []

    result = jsonify({'my_hostname': socket.gethostname(),
                      'your_ip': remote_ip,
                      'history': history
                     }), 200

    if remote_ip not in history:
        history.append(remote_ip)

    with open(statefile, "w+") as f:
        history = json.dump(history, f)    


    return result