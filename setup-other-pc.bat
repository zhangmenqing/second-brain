@echo off
REM =====================================================================
REM  第二大脑工作台 - 新电脑一键初始化（全自动）
REM  功能：安装 Git 后，双击本文件，按提示输入 token，即可完成：
REM    1. 克隆 GitHub 仓库到 E:/workbench
REM    2. 配置 git 代理（CLOUD UPUP 端口）
REM    3. 配置 git 使用 OpenSSL 后端（解决代理证书问题）
REM    4. 注册每小时自动同步定时任务
REM    5. 首次同步验证
REM  注意：token 只用于本次执行，不会写入任何文件
REM =====================================================================

echo ================================================================
echo   第二大脑工作台 - 新电脑初始化
echo ================================================================
echo.
echo  准备工作：
echo   1. 已安装 Git for Windows（https://git-scm.com）
echo   2. 这台电脑也有 E 盘
echo   3. 已连接 CLOUD UPUP 等 VPN（能访问 GitHub）
echo.

echo  请输入 GitHub 用户名（默认 zhangmenqing，直接回车用默认）：
set /p USER=用户名: 
if "%USER%"=="" set USER=zhangmenqing

echo.
echo  请输入 GitHub 私人访问令牌（token，有 repo 权限）：
set /p TOKEN=token: 

echo.
echo  请输入 CLOUD UPUP 代理端口（默认 7890，直接回车用默认）：
set /p PORT=端口: 
if "%PORT%"=="" set PORT=7890
echo.

if exist E:/workbench (
    echo  警告：E:/workbench 已存在，请先备份或删除后再运行本脚本。
    pause
    exit /b 1
)

echo  [1/5] 克隆仓库到 E:/workbench ...
git clone https://%USER%:%TOKEN%@github.com/zhangmenqing/second-brain.git E:/workbench

if errorlevel 1 (
    echo.
    echo  克隆失败，请检查：token 是否正确、VPN 是否连接、用户名是否正确。
    pause
    exit /b 1
)

cd /d E:/workbench

echo.
echo  [2/5] 配置 git 代理（127.0.0.1:%PORT%）...
git config --global http.proxy http://127.0.0.1:%PORT%
git config --global https.proxy http://127.0.0.1:%PORT%

echo  [3/5] 配置 git 使用 OpenSSL 后端...
git config --global http.sslbackend openssl

echo  [4/5] 注册每小时自动同步定时任务...
schtasks /create /tn "WorkbenchAutoSync" /tr "E:/workbench/sync.bat" /sc hourly /mo 1 /st 00:00 /f

echo  [5/5] 首次同步验证...
git pull

if errorlevel 1 (
    echo.
    echo  首次同步出现警告，但定时任务已注册。请确认 VPN 连接后双击 sync.bat。
) else (
    echo.
    echo  首次同步成功！
)

echo.
echo ================================================================
echo   完成！以后这台电脑每小时自动同步，你只管往文件夹里写。
echo   切换设备前无需手动操作，云端会保持最新。
echo   换 token 时双击 set-token.bat 即可。
echo ================================================================
pause
