#!/bin/bash

source add_to_file.sh

set -ex

if ! sudo -n echo "hi"; then
  echo "Error: must use sudo non-interactively; please run a sudo command"
fi

if [[ -z "$( which jq )" ]]; then
  echo -e "Error: must install 'jq'. Run:\n  sudo apt install jq"
  exit 1
fi

if [[ -n "$(which kubectl)" ]]; then
  echo "Stashing old kubectl"
  sudo mv "$(which kubectl)" /tmp/kubectl.backup
fi

# Get latest kubectl release
kubectl_version="$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"
# kubectl_version=v1.15.5 # latest version that works with kubeflow
kubectl_tar=kubernetes-client-linux-amd64.tar.gz
set +x
echo "Getting latest kubectl release (${kubectl_version})"
set -x
curl -L "https://storage.googleapis.com/kubernetes-release/release/${kubectl_version}/${kubectl_tar}" \
  | sudo -n tar \
           -xvzf - \
           --strip-components=3 \
           -C /usr/local/bin \
           "kubernetes/client/bin/kubectl"
sudo chmod +x /usr/local/bin/kubectl

# Install alias
add_to_file 'alias kc=kubectl' 'kubectl <-> kc alias' "${HOME}/.bashrc"

