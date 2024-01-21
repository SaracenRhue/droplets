#!/usr/bin/env bash

apt update
apt install git tmux htop -y

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker $USER
apt install docker-compose -y
systemctl enable docker
systemctl start docker
source ~/.bashrc
rm -fr get-docker.sh

docker buildx create --name mybuilder
docker buildx use mybuilder
docker buildx inspect --bootstrap
docker run -it --rm --privileged tonistiigi/binfmt --install all
echo "docker buildx build --platform linux/amd64,linux/arm64 -t saracenrhue/project:latest . --push" >> ~/.bash_history
source ~/.bashrc

echo "Done!"
sleep 3

tmux
