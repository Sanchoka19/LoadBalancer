#from flask import Flask

#app = Flask(__name__)

#@app.route('/')
#def home():
#    return "Hello, World1!"

#if __name__ == '__main__':
#    app.run(host='0.0.0.0', port=8282)


from flask import Flask
from prometheus_client import start_http_server, Summary, Counter, generate_latest

app = Flask(__name__)

# Create metrics
REQUEST_COUNT = Counter('app_requests_total', 'Total number of requests')
REQUEST_LATENCY = Summary('app_request_latency_seconds', 'Request latency in seconds')

@app.route('/')
def home():
    REQUEST_COUNT.inc()  # Increment the request count
    with REQUEST_LATENCY.time():  # Measure the latency of this request
        return "Hello, World2!"

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': 'text/plain; version=0.0.4; charset=utf-8'}

if __name__ == '__main__':
    start_http_server(8384)
    app.run(host='0.0.0.0', port=8383)
