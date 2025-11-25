#!/bin/bash
# Helper script to run vs-admin GUI (requires interactive terminal)
# This will display a live dashboard of the visa service
echo "Starting ZPR Visa Service GUI..."
echo "Press 'q' to quit"
echo ""
docker exec -it visa-service /app/bin/vs-admin -s 'https://[fd5a:5052::1]:8182' -c /conf/auth-ca.crt gui
