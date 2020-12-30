#!/bin/bash

set -ex

if [[ -z "$( which jq )" ]]; then
  echo -e "Error: must install 'jq'. Run:\n  sudo apt install jq"
  exit 1
fi

if [[ -n "$(which kubectl)" ]]; then
  echo "Stashing old kubectl"
  sudo mv "$(which kubectl)" /tmp/kubectl.backup
fi

# Get latest kubectl release
latest_release="$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"
# latest_release=v1.15.5 # latest version that works with kubeflow
set +x
echo "Getting latest kubectl release (${latest_release})"
set -x
curl -L --progress-bar "https://storage.googleapis.com/kubernetes-release/release/${latest_release}/kubernetes-client-linux-amd64.tar.gz" \
  | sudo tar -xvzf - --strip-components=3 -C /usr/local/bin "kubernetes/client/bin/kubectl"
sudo chmod +x /usr/local/bin/kubectl
