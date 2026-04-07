#!/bin/bash
set -euo pipefail

LOG="/tmp/helix-startup.log"
GATEWAZE_DIR="/home/retro/work/gatewaze"

exec > >(tee -a "$LOG") 2>&1
echo "=== Gatewaze startup $(date) ==="

# Check prerequisites
if ! command -v docker &>/dev/null; then
  echo "Error: docker is not installed"
  exit 1
fi

if ! docker info &>/dev/null; then
  echo "Error: Docker daemon is not running"
  exit 1
fi

cd "$GATEWAZE_DIR"

# First-time setup
if [ ! -f docker/.env ]; then
  echo "First run detected — copying docker/.env.example to docker/.env..."
  cp docker/.env.example docker/.env
fi

# Boot the stack using dev.sh (works without make)
echo "Starting gatewaze stack..."
bash dev.sh up

echo "=== Gatewaze startup complete ==="
