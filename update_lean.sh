#!/bin/bash

set -ex

latest_version="$(
  curl https://api.github.com/repos/leanprover/lean/releases | jq -r '.[0].tag_name'
)"

if [[ -d /opt/lean ]]; then
  sudo mv /opt/lean /opt/lean.backup
fi
sudo mkdir /opt/lean
curl -Lo - "https://github.com/leanprover/lean/releases/download/${latest_version}/lean-${latest_version#v}-linux.tar.gz" \
  | sudo tar -C /opt/lean --strip-components=1 -xvzf -
if [[ -d /opt/lean.backup ]]; then
  sudo rm -rf /opt/lean.backup
fi
