#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

echo "$DEBIAN_FRONTEND"

mkdir_update_install(){
# 改时区
date '+%Y-%m-%d %H:%M:%S'
cp -rv /etc/localtime /etc/localtime.bak.`date '+%Y-%m-%d_%H-%M-%S'`
rm -rfv /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone
date '+%Y-%m-%d %H:%M:%S'

# for((i=1;i<4;i++)) ; do
#       echo "try $i"
#       # 更新软件列表源
#       apt-get update
#       # 防止遇到无法拉取 https 源的情况，先使用 http 源并安装
#       apt-get -y install apt-transport-https ca-certificates apt-utils
# done

# dpkg -i /root/*.deb

# rm -rfv /root/*.deb

# 备份源
# cp -rv /etc/apt/sources.list /etc/apt/sources.list.bak

# 写入清华源
# cat << EOF > /etc/apt/sources.list
# deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
# deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
# deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
# deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
# EOF

# for((i=1;i<4;i++)) ; do
#         echo "try $i"
#         # 更新软件列表源
#         apt-get update
#         # 安装一些工具和locales
#         apt-get -y install vim git neofetch procps htop locales 
# done

# 备份源
cp -rfv /etc/apt/sources.list{,.backup}
cp -rfv /etc/apt/sources.list.d{,.backup}

# 恢复源
#mkdir -pv /etc/apt/sources.list.d
#cp -fv /usr/share/doc/apt/examples/sources.list /etc/apt/sources.list

# 写入 http 清华源
cat << EOF | tee /etc/apt/sources.list
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
deb-src http://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free

deb http://security.debian.org/debian-security bullseye-security main contrib non-free
deb-src http://security.debian.org/debian-security bullseye-security main contrib non-free
EOF

# 更新软件列表源
apt update

# 防止遇到无法拉取 https 源的情况，先使用 http 源并安装
apt-get -y install apt-transport-https ca-certificates apt-utils eatmydata aptitude

# 写入 https 清华源
sed -i 's;http;https;g' /etc/apt/sources.list

# 更新软件列表源
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true -y update

# 安装中文支持和其他工具
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true -y install vim git neofetch \
                                                                                 procps htop locales
}

install_sync(){
# 使用locale-gen命令生成中文本地支持
sed -i 's;# zh_CN.UTF-8 UTF-8;zh_CN.UTF-8 UTF-8;g;s;en_GB.UTF-8 UTF-8;# en_GB.UTF-8 UTF-8;g' /etc/locale.gen ; locale-gen zh_CN ; locale-gen zh_CN.UTF-8

# 写入环境变量
cat << EOF >> /root/.bashrc
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE=zh_CN.UTF-8
EOF

cat << EOF >> /root/.profile
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE=zh_CN.UTF-8
EOF

source /root/.bashrc /root/.profile

# 持久化
update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8 LANGUAGE=zh_CN.UTF-8

# 看看当前启用的本地支持
cat /etc/default/locale
locale
locale -a

# 安装 resilio-sync
mkdir -p /mnt/sync/conf /mnt/sync/storage /mnt/sync/data
cp -rv /root/rslsync /usr/bin/
cp -rv /root/run_sync /usr/bin/
cp -rv /root/sync.conf /mnt/sync/conf/
chmod -v u+x /usr/bin/run_sync /usr/bin/rslsync
rm -rfv /root/rslsync /root/run_sync
}

clean_remove(){
apt-get -y autoremove
apt-get -y autopurge
apt-get clean
rm -rfv  /var/lib/apt/lists/*

# 还原源
mv -v /etc/apt/sources.list.bak /etc/apt/sources.list
apt-get update

# 清除记录
history -c
echo '' > /root/.bash_history
}

mkdir_update_install
install_sync
clean_remove

# 脚本终结
echo 'it is done!'
