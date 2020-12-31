#!/bin/bash

set -e

# version=$(
#   curl -s https://api.github.com/repos/kubernetes/minikube/releases/latest \
#   | jq --raw-output '.name'
# )
if [[ "${1}" =~ --version=.* ]]; then
  version="${1##--version=}"
  echo "Installing minikube version ${version}"
else
  version="latest"
  echo "Installing latest minikube"
fi

set -x
curl -L -o /tmp/minikube "https://storage.googleapis.com/minikube/releases/${version}/minikube-linux-amd64" \
  && chmod +x /tmp/minikube \
  && sudo mv /tmp/minikube /usr/local/bin/
