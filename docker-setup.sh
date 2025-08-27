#!/bin/bash
set -e  # 脚本出错时立即退出

# 检查是否为 root 用户（安装/卸载需 root 权限）
if [ "$(id -u)" -ne 0 ]; then
    echo "错误：请使用 root 用户运行（sudo ./docker-setup.sh）"
    exit 1
fi

# -------------------------- 安装 Docker 函数 --------------------------
install_docker() {
    echo "===== 开始安装 Docker（基于官方脚本）====="
    
    # 1. 卸载旧版本 Docker（避免冲突）
    echo "1. 清理旧版本 Docker..."
    if command -v apt-get &> /dev/null; then  # Debian/Ubuntu 系列
        apt-get remove -y docker docker-engine docker.io containerd runc
    elif command -v yum &> /dev/null; then    # CentOS/RHEL 系列
        yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
    fi

    # 2. 执行 Docker 官方安装脚本（get.docker.com）
    echo "2. 下载并运行官方安装脚本..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm -f get-docker.sh  # 安装后删除临时脚本

    # 3. 启动 Docker 服务并设置开机自启
    echo "3. 配置 Docker 服务..."
    systemctl start docker
    systemctl enable docker --now

    # 4. 验证安装
    echo "4. 验证 Docker 安装..."
    if docker --version &> /dev/null; then
        echo "✅ Docker 安装成功！版本：$(docker --version)"
        echo "💡 建议：将当前用户添加到 docker 组（避免每次用 sudo）："
        echo "      sudo usermod -aG docker \$USER （执行后需注销重新登录生效）"
    else
        echo "❌ Docker 安装失败，请检查日志！"
        exit 1
    fi
}

# -------------------------- 卸载 Docker 函数 --------------------------
uninstall_docker() {
    echo "===== 开始卸载 Docker（含数据清理）====="
    read -p "警告：此操作会删除 Docker 所有镜像、容器和数据，是否继续？(y/N) " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "❌ 卸载已取消"
        exit 0
    fi

    # 1. 停止 Docker 服务
    echo "1. 停止 Docker 服务..."
    systemctl stop docker
    systemctl disable docker

    # 2. 卸载 Docker 软件包
    echo "2. 卸载 Docker 组件..."
    if command -v apt-get &> /dev/null; then
        apt-get purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
        apt-get autoremove -y  # 清理依赖
    elif command -v yum &> /dev/null; then
        yum remove -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    fi

    # 3. 清理 Docker 数据目录（镜像、容器、配置等）
    echo "3. 清理 Docker 数据目录..."
    rm -rf /var/lib/docker
    rm -rf /var/lib/containerd
    rm -rf /etc/docker

    # 4. 移除 docker 用户组（可选，若无需保留）
    if getent group docker &> /dev/null; then
        groupdel docker
        echo "4. 已移除 docker 用户组"
    fi

    echo "✅ Docker 完全卸载完成！"
}

# -------------------------- 脚本入口（参数判断） --------------------------
case "$1" in
    install)
        install_docker
        ;;
    uninstall)
        uninstall_docker
        ;;
    *)
        echo "用法：sudo ./docker-setup.sh [选项]"
        echo "选项："
        echo "  install    安装 Docker（基于官方脚本）"
        echo "  uninstall  卸载 Docker（含所有数据）"
        exit 1
        ;;
esac
