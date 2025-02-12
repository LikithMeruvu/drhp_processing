#!/usr/bin/env bash
set -e

# --- Frontend build ---
pushd frontend
npm install
npm run build  # Produces static files in "dist" or "build" folder
popd

# --- Backend (build-time tasks only) ---
pushd backend
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi

source .venv/bin/activate
pip install -r requirements.txt

# (Optionally run any scripts that produce *build artifacts* if needed)
# python3 some_script.py
popd
