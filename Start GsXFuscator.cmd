@echo off
setlocal
pushd "%~dp0"
python web/service.py --open
if errorlevel 1 pause
popd
