#!/bin/bash

set -ex

version="latest"
if [[ "${1}" =~ --version=/* ]]; then
  version="${1##--version=}"
fi

curl -L -o /tmp/minikube "https://storage.googleapis.com/minikube/releases/${version}/minikube-linux-amd64" \
  && chmod +x /tmp/minikube \
  && sudo mv /tmp/minikube /usr/local/bin/
