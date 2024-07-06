@echo off
cls
color f0
setLocal EnableExtensions EnableDelayedExpansion
set "installfolder=%~dp0"
set "installfolder=%installfolder:~0,-1%"
set "installername=%~n0.bat"
::================================================ ================================================== =============
:: CHECK ADMIN RIGHTS
fltmc >nul 2>&1
if "%errorlevel%" NEQ "0" (goto:UACPrompt) else (goto:gotAdmin)
::================================================ ================================================== =============
:UACPrompt
echo:
echo Requesting Administrative Privileges...
echo Press YES in UAC Prompt to Continue
echo:
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
echo args = "ELEV " >> "%temp%\GetAdmin.vbs"
echo For Each strArg in WScript.Arguments >> "%temp%\GetAdmin.vbs"
echo args = args ^& strArg ^& " " >> "%temp%\GetAdmin.vbs"
echo Next >> "%temp%\GetAdmin.vbs"
echo UAC.ShellExecute "%installername%", args, "%installfolder%", "runas", 1 >> "%temp%\GetAdmin.vbs"
cmd /u /c type "%temp%\GetAdmin.vbs">"%temp%\GetAdminUnicode. vbs"
cscript //nologo "%temp%\GetAdminUnicode.vbs"
del /f /q "%temp%\GetAdmin.vbs" >nul 2>&1
del /f /q "%temp%\GetAdminUnicode.vbs" >nul 2>&1
exit /B
::================================================ ================================================== =============
:gotAdmin
if "%1" NEQ "ELEV" shift /1
if exist "%temp%\GetAdmin.vbs" del /f /q "%temp%\GetAdmin.vbs"
if exist "%temp%\GetAdminUnicode.vbs" del /f /q "%temp%\GetAdminUnicode.vbs"
::================================================ ================================================== =============
@echo off
cls
color f0
cd/d %~dp0"
::================================================ ================================================== =============
call :MsgBox "Do you really want to enter in safe mode ?" "VBYesNo" "Boot Into Safe Mode"
if "%errorlevel%"=="7" (
exit /b
)
if "%errorlevel%"=="6" goto:SAFEMODE
:MsgBox prompt type title
setlocal enableextensions
set "tempFile=%temp%\%~nx0.%random%%random%%random%vbs .tmp"
>"%tempFile%" echo(WScript.Quit msgBox("%~1",%~2,"%~3") & cscript //nologo //e:vbscript "%tempFile%"
set "exitCode=%errorlevel%" & del "%tempFile%" >nul 2>nul
endlocal & exit /b %exitCode%
::================================================ ================================================== =============
:SAFEMODE
ver | findstr /i "10\.0\." > nul
if %ERRORLEVEL% EQU 0 (goto:Win10) else (goto:Others)
::================================================ ================================================== =============
:Win10
bcdedit /set {current} safeboot network
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run Once /v "*UndoSB" /t REG_SZ /d "bcdedit /deletevalue {current} safeboot"
SHUTDOWN -r -f -t 00
pause
goto:end
::================================================ ================================================== =============
:Others
ver | find "XP" > nul
if %ERRORLEVEL% == 0 (
bootcfg /raw /a /safeboot:network /id 1
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run Once /v "*UndoSB" /t REG_SZ /d "bootcfg /raw /fastdetect /id 1"
SHUTDOWN -r -f -t 00
) else (
bcdedit /set {current} safeboot network
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run Once /v "*UndoSB" /t REG_SZ /d "bcdedit /deletevalue {current} safeboot"
SHUTDOWN -r -f -t 00
)
goto:end
)
)
::================================================ ================================================== =============
:end 
::================================================ ================================================== =============
