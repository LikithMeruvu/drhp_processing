@echo off

REM Frontend startup
pushd frontend
start "Frontend Server" cmd /k "npm install && npm start"
popd

REM Backend startup
pushd backend
if not exist ".venv" (
    python -m venv .venv
)
call .venv\Scripts\activate.bat
pip install -r requirements.txt
start "Backend Server" cmd /k "uvicorn main:app --reload"
popd

pause