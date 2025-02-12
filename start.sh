#!/usr/bin/env bash
set -e

# --- Frontend build ---
pushd frontend

# Install dependencies
npm ci || npm install

# Explicitly install the missing Babel plugin (workaround for old CRA)
npm install --save-dev @babel/plugin-proposal-private-property-in-object

# Build the frontend
npm run build

popd

# --- Backend setup ---
pushd backend

# If virtual environment doesn't exist, create it
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi

# Activate virtual environment
source .venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt

# Start Uvicorn server in the background
uvicorn main:app --host 0.0.0.0 --port 8000 --reload &

popd

# Keep script running so background process doesn't exit immediately
wait
