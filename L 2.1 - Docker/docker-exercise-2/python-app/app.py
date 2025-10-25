# Create a simple Python app
#!/usr/bin/env python3
from flask import Flask
import datetime

app = Flask(__name__)

@app.route('/')
def home():
    return f'''
    <h1>🐍 My First - Python Flask App in Docker</h1>
    <p>Hello, I am Andres Lopez!</p>
    <p>Current time: {datetime.datetime.now()}</p>
    <p>This is my first Flask app in Docker!</p>
    '''

@app.route('/health')
def health():
    return {'status': 'healthy', 'timestamp': datetime.datetime.now().isoformat()}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
