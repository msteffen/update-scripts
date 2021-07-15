#!/bin/bash

set -ex

source_dir="$(dirname "$(readlink -f "${0}")")"
source "${source_dir}/latest_gh_release.sh"

sudo -n echo starting || { echo -e "need sudo privileges. Run\nsudo echo test"; exit 1; }

if [[ -z "$( which jq )" ]]; then
  echo -e "Error: must install 'jq'. Run:\n  sudo apt install jq"
  exit 1
fi

# Get latest kops release
version="$(latest_gh_release "kubernetes/kops")"

echo "Getting latest kops release (${version})"
wget -q --show-progress "https://github.com/kubernetes/kops/releases/download/${version}/kops-linux-amd64" \
  && chmod +x ./kops-linux-amd64 \
  && sudo -n mv ./kops-linux-amd64 /usr/local/bin/kops
