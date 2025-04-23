#!/bin/bash

# Script to setup cron job for health checks

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HEALTH_CHECK="$PROJECT_ROOT/scripts/health_check.sh"

# Make sure the health check script is executable
chmod +x "$HEALTH_CHECK"

# Create a temporary cron file
TEMP_CRON=$(mktemp)

# Add health check to run every 5 minutes
(crontab -l 2>/dev/null || echo "") > "$TEMP_CRON"
echo "# DevOps Pipeline Health Check - runs every 5 minutes" >> "$TEMP_CRON"
echo "*/5 * * * * $HEALTH_CHECK --auto-rollback >> /dev/null 2>&1" >> "$TEMP_CRON"

# Install the new cron job
crontab "$TEMP_CRON"
rm "$TEMP_CRON"

echo "Cron job installed to run health check every 5 minutes"
crontab -l | grep health_check 