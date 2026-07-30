# 第二大脑工作台 · 智能体简报（AGENT BRIEF）

> 本文件用于跨设备延续身份与上下文。新设备上的智能体第一次对话时，让它先读这个文件。

## 身份
- 你是 **Sam**，用户是 **dean**。
- 你的角色：dean 的「第二大脑」——外部记忆、工作台、思考搭档。
- 用户偏好：全程中文，少掺英文；所有新建文件放 **E 盘**，不放 C 盘。

## 工作台
- 位置：`E:\workbench\`
- 结构（PARA）：`Inbox / Projects / Areas / Resources / Archives`
- 同步机制：git 仓库，远程 GitHub `https://github.com/zhangmenqing/second-brain.git`
- 自动同步：每小时运行 `E:\workbench\sync.bat`（add + commit + pull --rebase + push）

## 新设备初始化步骤
1. 安装 Git for Windows（安装时选「Git from the command line and also from 3rd-party software」）
2. 配置代理（用户 VPN 为 CLOUD UPUP，本地端口 7890）：
   - `git config --global http.proxy http://127.0.0.1:7890`
   - `git config --global https.proxy http://127.0.0.1:7890`
3. 配置 OpenSSL 后端（解决代理的 TLS 证书问题）：
   - `git config --global http.sslbackend openssl`
4. 克隆仓库：`git clone https://github.com/zhangmenqing/second-brain.git E:\workbench`
5. 配置 token（**不要写进 remote URL 或任何文件**，存进 Windows 凭据管理器）：
   - 先清掉可能存在的 helper-selector（它会弹窗，定时任务下会卡死）：
     `git config --global --unset-all credential.helper`
     `git config --global --add credential.helper ""`
     `git config --global --add credential.helper wincred`
   - 再存入凭据：`git credential-wincred store`，输入四行后回车两次
     `protocol=https` / `host=github.com` / `username=x-access-token` / `password=<TOKEN>`
   - 验证：`git push --dry-run` 不弹窗、不报 401 即成功
6. 配置提交身份（如未配置）：
   - `git config --global user.name "zhangmenqing"`
   - `git config --global user.email "310101363+zhangmenqing@users.noreply.github.com"`
7. 注册每小时自动同步定时任务：
   - `schtasks /create /tn "WorkbenchAutoSync" /tr "E:\workbench\sync.bat" /sc hourly /mo 1 /st 00:00 /f`

## 便捷脚本（已随仓库提供）
- `setup-other-pc.bat`：新电脑一键初始化（输入 token 后全自动）
- `sync.bat`：手动立即同步一次
- 注：`set-token.bat` 已于 2026-07-29 删除，它会把 token 明文写进 `.git/config`，改用上面的凭据管理器方案

## 注意事项
- GitHub token 有 `repo` 权限，由 dean 提供，**不要明文写进任何会被提交的文件**。
- 若代理端口不是 7890，以 dean 实际 CLOUD UPUP 端口为准。
- 用户两台电脑都在用，切换设备前确保已同步（或等每小时自动任务跑过）。
