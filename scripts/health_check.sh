#!/bin/bash

# Health check script for Flask application

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_FILE="$PROJECT_ROOT/logs/health_checks.log"
APP_URL="http://localhost:5000/health"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Function to log messages
log_message() {
    echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
    echo "[$TIMESTAMP] $1"
}

# Check if app is running
if ! curl -s "$APP_URL" > /dev/null; then
    log_message "ERROR: Application is not responding at $APP_URL"
    
    # Trigger rollback if application is not responding
    if [ "$1" == "--auto-rollback" ]; then
        log_message "Initiating automatic rollback..."
        cd "$PROJECT_ROOT/ansible" && ansible-playbook rollback.yml
        
        # Check if rollback fixed the issue
        sleep 5
        if curl -s "$APP_URL" > /dev/null; then
            log_message "Rollback successful, application is now responding"
            exit 0
        else
            log_message "Rollback failed, application is still not responding"
            exit 1
        fi
    fi
    
    exit 1
fi

# Get health check data
HEALTH_DATA=$(curl -s "$APP_URL")

# Log health check result
log_message "SUCCESS: Application is healthy - $HEALTH_DATA"

exit 0 