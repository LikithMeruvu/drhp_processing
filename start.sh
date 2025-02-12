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

echo "Installing required dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Fix missing SQLite3 issue
echo "Ensuring SQLite3 support..."
apt-get update && apt-get install -y sqlite3 libsqlite3-dev
pip install pysqlite3-binary

# Optional: Verify SQLite installation
python3 -c "import sqlite3; print('SQLite installed successfully')"

echo "Starting Uvicorn..."
uvicorn main:app --host 0.0.0.0 --port 8000 --reload &
popd

echo "Deployment script executed successfully."
wait  # Ensures background processes stay active
