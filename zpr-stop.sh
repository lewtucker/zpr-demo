#!/bin/bash
# Stop the ZPR demo Docker containers
echo "Stopping ZPR demo containers..."
docker compose -f docker/docker-compose.yml down
echo "ZPR demo stopped."
