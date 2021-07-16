@ECHO OFF
TITLE SomethingSomething Tool
PUSHD %~dp0
ECHO Starting SomethingSomething.....
Powershell.exe -ExecutionPolicy Unrestricted -Command "& {Start-Process startapp.cmd -Verb RunAs}" 
POPD
ECHO SomethingSomething tool exiting.