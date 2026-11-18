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

:: --- Remove old entries added by this script (if any) ---
attrib -r "%HOSTS%"
findstr /v /c:"%TAG%" "%HOSTS%" > "%TEMP%\hosts.tmp"
copy /y "%TEMP%\hosts.tmp" "%HOSTS%" >nul

:: --- Sites to block (add or remove names here) ---
>>"%HOSTS%" echo.
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
) do >>"%HOSTS%" echo 0.0.0.0 %%D %TAG%

ipconfig /flushdns >nul

echo.
echo  Done - social media and YouTube are now blocked on this PC.
echo  Close and reopen any open browsers.
echo.
pause
