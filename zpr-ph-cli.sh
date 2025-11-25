#!/bin/bash
# Helper script to run ph adapter as client from the node container
docker exec node /app/bin/ph adapter -l all=DEBUG -c /conf/adapter-cli-conf.toml
