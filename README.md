# docker-arm64-resilio-sync
## dockerhub
<a href="https://hub.docker.com/r/smallflowercat1995/debian-sync" target="_blank">https://hub.docker.com/r/smallflowercat1995/debian-sync</a>
## 描述
    这是一个 arm64 的 resilio sync docker 构建材料  
    闲暇之余可以通过树莓派输入资源 key 将资源同步下载  
    由于官网的sync是分布式的所以没什么安全性，不过是个不错的工具  
    配置文件 docker-compose.yml 这个自己可以自定义修改  
    整个项目不难，看看配置文件，看看脚本，再看看目录结构，肯定就理解了
    .  
    ├── docker-compose.yml                       # 这个是 docker-compose.yml 配置文件  
    ├── Dockerfile                               # 这个是 docker 构建文件  
    ├── package                                  # 这个是二进制文件、脚本、配置文件所在目录  
    │   ├── install.sh                           # 这个是构建镜像的时候在容器内执行流程的脚本  
    │   ├── rslsync                              # 这个是通过 arm64 设备安装官网安装包得到的二进制文件  
    │   ├── run_sync                             # 这个是启动 rslsync 的脚本  
    │   └── sync.conf                            # 这个是 rslsync 默认配置文件，也可以按照需求配置  
    └── ResilioSyncPro                           # 这个是就不做介绍了，自行研究吧，你懂的  
        └── ResilioSyncPro.btskey  

## 依赖
    arm64 设备
    docker 程序
    docker-compose python程序
    我目前能想到的必要程序就这些吧

## 构建命令
    # clone 项目
    git clone https://github.com/smallflowercat1995/docker-arm64-resilio-sync.git
    # 进入目录
    cd docker-arm64-resilio-sync
    # 无缓存构建
    docker-compose build --no-cache

## 构建完成后 后台启动
    docker-compose up -d

## 感谢
resilio sync 官网：https://www.resilio.com/  
Resilio, Inc. ：https://github.com/bt-sync  

## 参考
Install Docker Engine：https://docs.docker.com/engine/install/  
Install Docker Compose：https://docs.docker.com/compose/install/  
sync-docker：https://github.com/bt-sync/sync-docker  
Overview of Docker Compose：https://docs.docker.com/compose/  
