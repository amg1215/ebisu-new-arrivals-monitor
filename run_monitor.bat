@echo off
rem Runs the Ebisu new-arrivals monitor. Invoked by Windows Task Scheduler.
cd /d "%~dp0"
".venv\Scripts\python.exe" monitor.py
