@ECHO OFF
TITLE SomethingSomething Tool
PUSHD %~dp0
ECHO Starting SomethingSomething....
Powershell.exe Set-executionpolicy bypass
Powershell.exe -File powershellfile.ps1
POPD