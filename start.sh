#!/usr/bin/env bash
set -e  # Exit script on error

# --- Frontend build ---
pushd frontend
echo "Installing frontend dependencies..."
npm ci || npm install

echo "Fixing Babel issue..."
npm install --save-dev @babel/plugin-proposal-private-property-in-object

echo "Building frontend..."
CI=false npm run build  # Prevents warnings from failing the build
popd

# --- Backend setup ---
pushd backend
echo "Checking for Python 3..."
if ! command -v python3 &> /dev/null; then
    echo "Python 3 not found, exiting..."
    exit 1
fi

echo "Setting up virtual environment..."
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi

source .venv/bin/activate
pip install pysqlite3-binary
pip install -r requirements.txt

echo "Starting Uvicorn..."
uvicorn main:app --host 0.0.0.0 --port 8000 --reload &
popd

echo "Deployment script executed successfully."
wait  # Ensures background processes stay active
