@echo off
title Saper
cd /d "%~dp0"
start "Saper" /b powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0Saper.ps1"
exit
