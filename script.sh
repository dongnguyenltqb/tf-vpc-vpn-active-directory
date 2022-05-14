#! /bin/bash
cd /home/ubuntu
sudo apt-get update
sudo apt install -y zip unzip curl wget nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
