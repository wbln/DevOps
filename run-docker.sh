#!/bin/bash

hub_ver="2018.3.11035"
youtrack_ver="2018.3.47965"
upsource_ver="2018.2.1013"
hub_port=$1
youtrack_port=$2
upsource_port=$3
teamcity_port=$4
portainer_port=$4
base="jetbrains"
jb_products=(hub youtrack upsource)
ts_agents=(test dev deploy)

sudo rm -f /etc/pacman.d/mirrorlist 

echo "Server = https://mirror.yandex.ru/archlinux/\$repo/os/\$arch
Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch
" | sudo tee --append /etc/pacman.d/mirrorlist

sudo pacman -Sy
sudo pacman -S docker docker-compose git --noconfirm
sudo -sn gpasswd -a vagrant docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo systemctl status docker.service | grep -e "Active: "

docker --version
docker-compose --version

for inst in ${jb_products[*]}
do
	eval port='$'${inst}_port
	eval ver='$'${inst}_ver 
    sudo mkdir -pv ~/${base}/${inst}/data ~/${base}/${inst}/conf ~/${base}/${inst}/logs ~/${base}/${inst}/backups
    sudo chown -R 13001:13001 ~/${base}/${inst}/data ~/${base}/${inst}/conf ~/${base}/${inst}/logs ~/${base}/${inst}/backups

    sudo docker run -d -it --name ${inst}-server  \
    -v ~/${base}/${inst}/data:/opt/${inst}/data  \
    -v ~/${base}/${inst}/conf:/opt/${inst}/conf  \
    -v ~/${base}/${inst}/logs:/opt/${inst}/logs  \
    -v ~/${base}/${inst}/backups:/opt/${inst}/backups  \
    -p ${port}:8080 \
    ${base}/${inst}:${ver}

id=$(sudo docker ps -a | grep -e "${inst}-server" | cut -c-3)
echo $id
sleep 20
sudo docker cp $id:/opt/${inst}/conf/internal/services/configurationWizard/wizard_token.txt ./${inst}_token
done

#== TeamCity ==
inst="teamcity"
eval port='$'${inst}_port
eval ver='$'${inst}_ver 
sudo mkdir -pv ~/${base}/${inst}/data ~/${base}/${inst}/logs ~/${base}/${inst}/conf
sudo chown -R 13001:13001 ~/${base}/${inst}/data ~/${base}/${inst}/logs ~/${base}/${inst}/conf
sudo docker run -d -it --name teamcity-server \
    -v ~/${base}/${inst}/data:/opt/${inst}_server/data \
    -v ~/${base}/${inst}/logs:/opt/${inst}/logs \
    -p ${port}:8111 \
    ${base}/${inst}-server

#== TeamCity Agent ==
for name in ${ts_agents[*]}
do
    sudo docker run -d -it --name ${name}-agent \
        -e SERVER_URL="<host_ip>:8840" \
        -e AGENT_NAME=${name} \
        -v ~/${base}/${inst}/conf:/data/${inst}_agent/conf \
        ${base}/${inst}-agent
done

sudo docker volume create portainer_data
sudo docker run -d -it --name portainer-server \
-v /var/run/docker.sock:/var/run/docker.sock \
-v portainer_data:/data \
-p ${portainer_port}:9000 \
portainer/portainer

echo "======== Hub token ========="
echo "=== $(cat ./hub_token) ==="
echo "============================"
echo " "
echo "====== YouTrack token ======"
echo "=== $(cat ./youtrack_token) ==="
echo "============================"
echo " "
echo "====== UpSource token ======"
echo "=== $(cat ./upsource_token) ==="
echo "============================"
