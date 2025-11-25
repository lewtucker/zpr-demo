#!/bin/bash
# Helper script to run vs-admin from the visa-service container
docker exec visa-service /app/bin/vs-admin "$@"
