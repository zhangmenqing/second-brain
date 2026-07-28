@echo off
REM =====================================================================
REM  注册「每小时自动同步」的定时任务（只需在本机跑一次）
REM  双击本文件即可；若提示权限不足，请右键「以管理员身份运行」
REM =====================================================================

echo 正在注册每小时自动同步任务（WorkbenchAutoSync）...
schtasks /create /tn "WorkbenchAutoSync" /tr "E:\workbench\sync.bat" /sc hourly /mo 1 /st 00:00 /f

if errorlevel 1 (
    echo.
    echo 注册失败。请尝试右键本文件 -> 以管理员身份运行。
    pause
    exit /b 1
)

echo.
echo 成功！以后每小时会自动把 E:\workbench 同步到 GitHub。
echo 你也可以随时双击 sync.bat 手动立即同步。
pause
