@echo off
REM =====================================================================
REM  设置/更新 GitHub 私人访问令牌（token）
REM  用法：双击运行，按提示粘贴你的 GitHub token，脚本会自动配置 remote 并测试 push
REM  注意：token 只用于本次命令执行，不会被保存到任何文件
REM =====================================================================

cd /d E://workbench

echo ================================================================
echo   设置 GitHub 令牌
echo ================================================================
echo.
echo  当前 remote 地址：
git remote -v
echo.
echo  请输入你的 GitHub 私人访问令牌（token）：
echo  （从 GitHub 设置 -> 开发者设置 -> 私人访问令牌里复制，右键粘贴即可）
echo.
set /p TOKEN=token: 

echo.
echo  正在更新 remote URL...
git remote set-url origin "https://zhangmenqing:%TOKEN%@github.com/zhangmenqing/second-brain.git"

echo.
echo  更新后的 remote 地址：
git remote -v

echo.
echo  正在测试推送...
git push

if errorlevel 1 (
    echo.
    echo ================================================================
    echo   推送失败。
    echo   常见原因：
    echo     1. token 复制不完整或包含空格
    echo     2. VPN（CLOUD UPUP）没有开启
    echo     3. GitHub 上已撤销这个 token
    echo.
    echo   请检查后再试一次。
    echo ================================================================
    pause
    exit /b 1
)

echo.
echo ================================================================
echo   成功！token 已更新并验证通过。
echo   以后每小时自动同步都会使用这个新 token。
echo ================================================================
pause
