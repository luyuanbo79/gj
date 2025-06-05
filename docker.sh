#!/bin/bash
 
# 创建 /etc/docker 目录，如果目录已存在则不报错
sudo mkdir -p /etc/docker
 
# 写入 daemon.json 文件内容
sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "registry-mirrors": [
        "https://dockerproxy.com",
        "https://docker.mirrors.ustc.edu.cn",
        "https://docker.nju.edu.cn",
        "https://cr.console.aliyun.com",
        "https://docker.mirrors.ustc.edu.cn",
        "http://hub-mirror.c.163.com",
        "https://hub.daocloud.io",
        "http://mirror.azure.cn",
        "https://mirror.baidubce.com",
        "https://docker.mirrors.sjtug.sjtu.edu.cn",
        "https://docker.nju.edu.cn",
        "https://docker.hpcloud.cloud",
        "https://docker.m.daocloud.io",
        "https://docker.unsee.tech",
        "https://docker.1panel.live",
        "http://mirrors.ustc.edu.cn",
        "https://docker.chenby.cn",
        "http://mirror.azure.cn",
        "https://dockerpull.org",
        "https://dockerhub.icu",
        "https://hub.rat.dev",
        "https://docker.m.daocloud.io",
        "https://dockerproxy.com",
        "https://docker.mirrors.ustc.edu.cn",
        "https://docker.nju.edu.cn",
        "https://cr.console.aliyun.com",
        "https://ccr.ccs.tencentyun.com",
        "https://dockerproxy.com",
        "https://hub-mirror.c.163.com",
        "https://mirror.baidubce.com",
        "https://hubgw.docker.com", 
        "https://docker.1ms.run", 
        "https://www.mirrorify.net", 
        "https://docker-pull.ygxz.in", 
        "https://docker.1yidc.com", 
        "https://dockerproxy.net", 
        "https://docker.aityp.com", 
        "https://www.container.fish",
        "https://docker.sheepx.us.kg",
        "https://docker.luyb.dpdns.org",
        "https://docker.luyb2.dpdns.org"
    ]
}
EOF
 
# 重新加载 systemd 配置
sudo systemctl daemon-reload
 
# 重启 Docker 服务
sudo systemctl restart docker
