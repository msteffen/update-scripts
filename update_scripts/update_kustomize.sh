#!/bin/bash

curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest \
  | jq -r '.assets[].browser_download_url | select(test("linux"))' \
  | xargs curl -Lo /dev/shm/kustomize
chmod +x /dev/shm/kustomize
sudo mv /dev/shm/kustomize /usr/local/bin/
