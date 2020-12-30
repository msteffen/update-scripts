#!/bin/bash

set -ex

sudo -n echo starting || { echo -e "need sudo privileges. Run\nsudo echo test"; exit 1; }

if [[ -z "$( which jq )" ]]; then
  echo -e "Error: must install 'jq'. Run:\n  sudo apt install jq"
  exit 1
fi

# Get latest kops release
latest_release="$(
  curl -s https://api.github.com/repos/kubernetes/kops/releases \
    | jq -r '.[].name' \
    | sed 's/^v//' \
    | grep -Ev 'alpha|beta|rc' \
    | sort \
    | tail -n 1
)"

echo "Getting latest kops release (${latest_release})"
wget -q --show-progress "https://github.com/kubernetes/kops/releases/download/${latest_release}/kops-linux-amd64" \
  && chmod +x ./kops-linux-amd64 \
  && sudo -n mv ./kops-linux-amd64 /usr/local/bin/kops
