#!/bin/bash

set -ex

ubuntu_version=$(lsb_release -sc)
if [[ -z "${ubuntu_version}" ]]; then
  echo "lsb_release doesn't work; this script must be run on ubuntu" >/dev/stderr
  exit 1
fi

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
yes | sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${ubuntu_version} stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo groupadd -f docker # -f just means exit successfully if 'docker' exists
sudo usermod -aG docker $USER
