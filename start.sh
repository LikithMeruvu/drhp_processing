#!/usr/bin/env bash
set -e

# --- Frontend startup ---
pushd frontend
npm install
# Run your frontend dev server in the background
npm start &
popd

# --- Backend startup ---
pushd backend
if [ ! -d ".venv" ]; then
    python -m venv .venv
fi

# Activate the virtual environment
source .venv/bin/activate

pip install -r requirements.txt

# Run Uvicorn in the background
uvicorn main:app --reload &
popd

# Wait so the script doesn't exit immediately and kill background jobs
wait
