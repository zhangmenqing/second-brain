@echo off
REM =====================================================================
REM  另一台电脑的首次初始化脚本（只需在新电脑上跑一次）
REM  功能：克隆工作台到 E:\workbench，并注册每小时自动同步任务
REM =====================================================================

echo ================================================================
echo   第二大脑工作台 - 新电脑初始化
echo ================================================================
echo.
echo  准备工作：
echo   1. 已安装 Git（https://git-scm.com）
echo   2. 这台电脑也有 E 盘
echo.
pause

echo.
echo  [1/2] 正在从 GitHub 克隆工作台到 E:\workbench ...
echo        稍后会弹出 GitHub 登录框：
echo          用户名：zhangmenqing
echo          密码：粘贴你的 GitHub 私人访问令牌（token，不是登录密码）
echo.
git clone https://github.com/zhangmenqing/second-brain.git E:\workbench

if errorlevel 1 (
    echo.
    echo 克隆失败，请检查网络 / token 是否正确，然后重试本脚本。
    pause
    exit /b 1
)

echo.
echo  [2/2] 注册每小时自动同步任务 ...
schtasks /create /tn "WorkbenchAutoSync" /tr "E:\workbench\sync.bat" /sc hourly /mo 1 /st 00:00 /f

echo.
echo ================================================================
echo   完成！以后这台电脑每小时自动同步，你只管往文件夹里写。
echo   切换设备前无需手动操作，云端会保持最新。
echo ================================================================
pause
