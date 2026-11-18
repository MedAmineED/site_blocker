@echo off
:: ============================================================
::  Block social media + YouTube on this PC (via hosts file)
::  Double-click it. It will ask for admin rights.
::  Safe to run again - it replaces its own old entries.
:: ============================================================

:: --- Re-launch as Administrator if needed ---
net session >nul 2>&1
if errorlevel 1 (
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set "HOSTS=%SystemRoot%\System32\drivers\etc\hosts"
set "TAG=#SOCIALBLOCK"

:: --- One-time backup of the original hosts file ---
if not exist "%HOSTS%.bak" copy "%HOSTS%" "%HOSTS%.bak" >nul

:: --- Build the new hosts file in a temp file first ---
:: (old entries added by this script are dropped, then the list is re-added)
set "NEW=%TEMP%\hosts.tmp"
attrib -r "%HOSTS%" >nul 2>&1
findstr /v /c:"%TAG%" "%HOSTS%" > "%NEW%"

:: --- Sites to block (add or remove names here) ---
>>"%NEW%" echo.
for %%D in (
    youtube.com www.youtube.com m.youtube.com music.youtube.com youtu.be youtube-nocookie.com www.youtube-nocookie.com youtubei.googleapis.com
    facebook.com www.facebook.com m.facebook.com web.facebook.com mbasic.facebook.com fb.com www.fb.com messenger.com www.messenger.com
    instagram.com www.instagram.com
    threads.net www.threads.net threads.com www.threads.com
    tiktok.com www.tiktok.com m.tiktok.com vm.tiktok.com
    x.com www.x.com twitter.com www.twitter.com mobile.twitter.com
    snapchat.com www.snapchat.com web.snapchat.com
    reddit.com www.reddit.com old.reddit.com
    pinterest.com www.pinterest.com
) do >>"%NEW%" echo 0.0.0.0 %%D %TAG%

:: --- Write it over the real hosts file, and check that it really worked ---
copy /y "%NEW%" "%HOSTS%" >nul 2>&1
if errorlevel 1 goto :failed
findstr /c:"%TAG%" "%HOSTS%" >nul 2>&1
if errorlevel 1 goto :failed

ipconfig /flushdns >nul

echo.
echo  Done - social media and YouTube are now blocked on this PC.
echo  Close ALL browser windows and reopen them.
echo.
pause
exit /b 0

:failed
echo.
echo  FAILED - Windows refused to change the hosts file. NOTHING is blocked.
echo.
echo  The script is running as Administrator, so something else is
echo  protecting this file:
echo    %HOSTS%
echo.
echo  Most likely your antivirus. Look for a setting like
echo  "protect hosts file" / "self-defense" / "ransomware protection" /
echo  "controlled folder access", turn it off or allow this script,
echo  then run this file again.
echo.
pause
exit /b 1
