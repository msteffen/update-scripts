#!/bin/bash

set -e

apt_packages=(
  vim
  unzip
  git
  make
  jq
  silversearcher-ag
  dnsutils
  apt-transport-https # for 'gcloud' installation (not sure why--docs request it)
  ca-certificates
  curl
  gnupg # for 'gcloud' installation
  gnupg-agent # for 'docker' installation
  software-properties-common # for 'add-apt-repository', part of docker install
  python3
  python3-setuptools # for 'python 3 -m easy_install'
  cmake
  python-dev
  python3-dev
  lsb-core
  uuid
);
sudo -n apt update -y
sudo -n apt install -y "${apt_packages[@]}"
sudo -n apt upgrade -y
