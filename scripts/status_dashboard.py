#!/usr/bin/env python3

import os
import json
import datetime
import http.server
import socketserver
from pathlib import Path
import subprocess
import threading
import time
import urllib.request

# Get project root directory
PROJECT_ROOT = Path(os.path.dirname(os.path.abspath(__file__))).parent

# Configuration
PORT = 8080
LOG_FILE = PROJECT_ROOT / "logs" / "health_checks.log"
APP_URL = "http://localhost:5000/health"
CHECK_INTERVAL = 30  # seconds

# Ensure log directory exists
os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)

# HTML template for the dashboard
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>DevOps Pipeline Status Dashboard</title>
    <meta http-equiv="refresh" content="30">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c3e50;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }
        .status {
            margin: 20px 0;
            padding: 15px;
            border-radius: 4px;
        }
        .healthy {
            background-color: #d5f5e3;
            border-left: 5px solid #2ecc71;
        }
        .unhealthy {
            background-color: #f5d5d5;
            border-left: 5px solid #e74c3c;
        }
        .unknown {
            background-color: #fdebd0;
            border-left: 5px solid #f39c12;
        }
        .section {
            margin-top: 30px;
        }
        .log {
            background-color: #f9f9f9;
            padding: 10px;
            border-radius: 4px;
            height: 300px;
            overflow-y: auto;
            font-family: monospace;
            font-size: 12px;
        }
        .timestamp {
            color: #7f8c8d;
            font-size: 0.8em;
        }
        .refresh {
            text-align: right;
            color: #7f8c8d;
            font-size: 0.8em;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>DevOps Pipeline Status Dashboard</h1>
        <div class="refresh">Auto-refreshes every 30 seconds. Last updated: {timestamp}</div>
        
        <div class="section">
            <h2>Application Status</h2>
            <div class="status {status_class}">
                <strong>Status:</strong> {status}
                <br>
                <span class="timestamp">Last checked: {health_timestamp}</span>
            </div>
        </div>
        
        <div class="section">
            <h2>Deployment Information</h2>
            <p><strong>Current Version:</strong> {version}</p>
            <p><strong>Deployment Time:</strong> {deploy_time}</p>
        </div>
        
        <div class="section">
            <h2>Recent Health Checks</h2>
            <div class="log">
                {health_logs}
            </div>
        </div>
    </div>
</body>
</html>
"""

class StatusHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Only handle root path
        if self.path != '/':
            self.send_error(404)
            return
            
        # Get application status
        app_status = get_app_status()
        
        # Get recent logs
        logs = get_recent_logs()
        
        # Get deployment info
        deploy_info = get_deployment_info()
        
        # Set status class based on health
        if app_status['status'] == 'healthy':
            status_class = 'healthy'
        elif app_status['status'] == 'unhealthy':
            status_class = 'unhealthy'
        else:
            status_class = 'unknown'
        
        # Format logs for HTML
        formatted_logs = "<br>".join(logs)
        
        # Create HTML response
        html = HTML_TEMPLATE.format(
            timestamp=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            status=app_status['status'],
            status_class=status_class,
            health_timestamp=app_status['timestamp'],
            version=deploy_info['version'],
            deploy_time=deploy_info['time'],
            health_logs=formatted_logs
        )
        
        # Send response
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(html.encode())
        
def get_app_status():
    try:
        with urllib.request.urlopen(APP_URL, timeout=5) as response:
            data = json.loads(response.read().decode())
            return {
                'status': 'healthy',
                'timestamp': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                'data': data
            }
    except Exception as e:
        return {
            'status': 'unhealthy',
            'timestamp': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            'error': str(e)
        }

def get_recent_logs(num_lines=50):
    logs = []
    try:
        if os.path.exists(LOG_FILE):
            with open(LOG_FILE, 'r') as f:
                logs = f.readlines()[-num_lines:]
    except Exception as e:
        logs.append(f"Error reading logs: {str(e)}")
    
    return logs

def get_deployment_info():
    try:
        active_symlink = os.path.join(PROJECT_ROOT, "active")
        if os.path.exists(active_symlink) and os.path.islink(active_symlink):
            # Get the target of the symlink
            target = os.readlink(active_symlink)
            
            # Get deployment time from directory modification time
            mtime = os.path.getmtime(target)
            deploy_time = datetime.datetime.fromtimestamp(mtime).strftime("%Y-%m-%d %H:%M:%S")
            
            # Try to get version from health endpoint
            version = "1.0.0"  # Default version
            try:
                with urllib.request.urlopen(APP_URL, timeout=2) as response:
                    data = json.loads(response.read().decode())
                    if 'version' in data:
                        version = data['version']
            except:
                pass
                
            return {
                'version': version,
                'time': deploy_time
            }
    except Exception as e:
        pass
        
    return {
        'version': 'Unknown',
        'time': 'Unknown'
    }

def run_health_checker():
    while True:
        try:
            status = get_app_status()
            timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            log_entry = f"[{timestamp}] Status: {status['status']}"
            
            with open(LOG_FILE, 'a') as f:
                f.write(log_entry + "\n")
                
        except Exception as e:
            print(f"Error in health checker: {e}")
            
        time.sleep(CHECK_INTERVAL)

def main():
    # Start health checker in background
    checker_thread = threading.Thread(target=run_health_checker, daemon=True)
    checker_thread.start()
    
    # Start web server
    with socketserver.TCPServer(("", PORT), StatusHandler) as httpd:
        print(f"Status dashboard running at http://localhost:{PORT}")
        httpd.serve_forever()

if __name__ == "__main__":
    main() 