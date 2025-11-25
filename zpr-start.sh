#!/bin/bash
# Start the ZPR demo Docker containers
echo "Starting ZPR demo containers..."
docker compose -f docker/docker-compose.yml up -d
echo ""
echo "ZPR demo started. Containers running:"
docker compose -f docker/docker-compose.yml ps
echo ""
echo "To view logs: docker compose -f docker/docker-compose.yml logs -f"
echo "To stop: ./zpr-stop.sh"
