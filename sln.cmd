@echo off
setlocal

pushd %~dp0
set ROOT_PATH=%CD%

set BUILD_TYPE=%~1
if NOT DEFINED BUILD_TYPE set BUILD_TYPE=Debug
if /i "%BUILD_TYPE%" == "Debug" goto :Gen
if /i "%BUILD_TYPE%" == "Release" goto :Gen
set ERR_MSG=Usage: %0 [build_type]
set EXIT_CODE=1
goto :Quit

:Gen
slngen.exe -c %BUILD_TYPE% -d .vs dirs.proj
set EXIT_CODE=%ERRORLEVEL%
if NOT "%EXIT_CODE%" == "0" set ERR_MSG=slngen.exe failed.

:Quit
popd
if NOT "%EXIT_CODE%" == "0" echo %ERR_MSG%
exit /b %EXIT_CODE%
