#!/bin/bash

# Script to start the status dashboard

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DASHBOARD_SCRIPT="$PROJECT_ROOT/scripts/status_dashboard.py"

# Make sure the dashboard script is executable
chmod +x "$DASHBOARD_SCRIPT"

# Start the dashboard
echo "Starting status dashboard..."
"$DASHBOARD_SCRIPT" &

# Store the PID
echo $! > "$PROJECT_ROOT/dashboard.pid"
echo "Dashboard started with PID $(cat "$PROJECT_ROOT/dashboard.pid")"
echo "Visit http://localhost:7070 to view the dashboard" 