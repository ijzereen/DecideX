#!/bin/bash

# Post-deployment hook for Elastic Beanstalk
# This script runs after the application is deployed

echo "Starting post-deployment tasks..."

# Set environment variables
export PYTHONPATH="/var/app/current:$PYTHONPATH"

# Navigate to application directory
cd /var/app/current

# Create logs directory if it doesn't exist
mkdir -p logs

# Set proper permissions
chmod +x application.py

# Test the application
echo "Testing application health..."
python -c "
import sys
sys.path.insert(0, '/var/app/current')
try:
    from main import app
    print('Application imported successfully')
except Exception as e:
    print(f'Application import failed: {e}')
    sys.exit(1)
"

echo "Post-deployment tasks completed successfully"
