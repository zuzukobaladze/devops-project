from flask import Flask, render_template, request, jsonify
import os
import datetime

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

# some changes
@app.route('/submit', methods=['POST'])
def submit():
    name = request.form.get('name', 'Anonymous')
    message = request.form.get('message', '')
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    return jsonify({
        'status': 'success',
        'data': {
            'name': name,
            'message': message,
            'timestamp': timestamp
        }
    })

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.datetime.now().isoformat(),
        'version': '1.0.0'
    })

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True) 