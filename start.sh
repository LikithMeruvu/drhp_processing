#!/usr/bin/env bash
set -e  # Exit script on error

# --- Frontend build ---
pushd frontend

echo "Installing frontend dependencies..."
npm ci || npm install

echo "Fixing Babel issue..."
npm install --save-dev @babel/plugin-proposal-private-property-in-object

echo "Building frontend..."
npm run build

popd

# --- Backend setup ---
pushd backend

echo "Checking for Python 3..."
if ! command -v python3 &> /dev/null; then
    echo "Error: Python3 not found! Install it or use a serverless function."
    exit 1
fi

echo "Setting up virtual environment..."
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi

source .venv/bin/activate
pip install -r requirements.txt

echo "Starting Uvicorn..."
uvicorn main:app --host 0.0.0.0 --port 8000 --reload &

popd

echo "Script execution completed."
wait
