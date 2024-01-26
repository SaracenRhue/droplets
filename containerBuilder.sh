#!/usr/bin/env bash

apt update && apt upgrade -y
apt install git tmux htop python3 python3-pip python-is-python3 nodejs npm wget -y
curl -fsSL https://tailscale.com/install.sh | sh

curl -fsSL https://get.docker.com | sh 
usermod -aG docker $USER
apt install docker-compose -y
systemctl enable docker && systemctl start docker
source ~/.bashrc

docker buildx create --name mybuilder
docker buildx use mybuilder
docker buildx inspect --bootstrap
docker run -it --rm --privileged tonistiigi/binfmt --install all
echo "docker buildx build --platform linux/amd64,linux/arm64 -t saracenrhue/project:latest . --push" >> ~/.bash_history
source ~/.bashrc

echo "Done!"
sleep 3

tmux
