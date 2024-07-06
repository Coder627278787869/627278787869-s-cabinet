@echo off
echo Back up in progress.....
xcopy "%appdata%\Mozilla\firefox\Profiles\eneter-your-profile-folder" "X:\Documents\backup-files\Mozilla" /E /V /Y /C
echo back up completed
Pause

Rem change x: with letter of partition where you want to put your's backup folder
