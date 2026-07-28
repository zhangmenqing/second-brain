@echo off
cd /d E:\workbench
(
echo === GIT VERSION ===
git --version
echo.
echo === GIT STATUS ===
git status
echo.
echo === GIT REMOTE ===
git remote -v
echo.
echo === SCHTASKS TEST ===
schtasks /? >nul 2>&1 && echo schtasks OK || echo schtasks FAILED
echo.
echo === FILES ===
dir *.bat
) > debug.txt 2>&1
echo 诊断完成，记事本会打开 debug.txt，请把里面的内容发给我。
notepad debug.txt
