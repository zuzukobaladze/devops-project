#!/bin/bash

# Script to start the Flask application

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ACTIVE_APP="$PROJECT_ROOT/active"

# Check if active symlink exists
if [ ! -L "$ACTIVE_APP" ]; then
    echo "ERROR: No active deployment found. Please deploy the application first."
    exit 1
fi

cd "$ACTIVE_APP" || exit 1
echo "Starting Flask application from $ACTIVE_APP"
python3 app.py 