@echo off
REM =====================================================================
REM  Workbench 自动同步脚本
REM  功能：把 E:\workbench 的改动提交并推送到 GitHub（无人值守可跑）
REM  用法：双击手动跑，或由 Windows 定时任务每小时自动跑
REM =====================================================================
cd /d E:\workbench

REM === 定位 git（自动化/定时任务环境下 PATH 可能不含 git）===
set "GIT_HOME="
if exist "%USERPROFILE%\.workbuddy\vendor\PortableGit\mingw64\bin\git.exe" set "GIT_HOME=%USERPROFILE%\.workbuddy\vendor\PortableGit\mingw64\bin"
if not defined GIT_HOME if exist "C:\Program Files\Git\cmd\git.exe" set "GIT_HOME=C:\Program Files\Git\cmd"
if not defined GIT_HOME if exist "C:\Program Files\Git\bin\git.exe" set "GIT_HOME=C:\Program Files\Git\bin"
if not defined GIT_HOME if exist "C:\Program Files (x86)\Git\bin\git.exe" set "GIT_HOME=C:\Program Files (x86)\Git\bin"
if defined GIT_HOME set "PATH=%GIT_HOME%;%PATH%"

REM 日志目录（不进 git，见 .gitignore 的 .sync/）
if not exist ".sync" mkdir ".sync"
set LOG=.sync\sync.log

echo [%date% %time%] === auto-sync start === >> "%LOG%"

REM 1) 把全部改动纳入暂存
git add -A >> "%LOG%" 2>&1

REM 2) 提交（没有改动时 git 会提示 nothing to commit，属正常）
git commit -m "auto-sync %date% %time%" >> "%LOG%" 2>&1

REM 3) 先拉取远端（rebase + autostash，保持线性、避免本地改动丢失）
git pull --rebase --autostash >> "%LOG%" 2>&1

REM 4) 推送
git push >> "%LOG%" 2>&1

echo [%date% %time%] === auto-sync done (exit %errorlevel%) === >> "%LOG%"
echo. >> "%LOG%"
