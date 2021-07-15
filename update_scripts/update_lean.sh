#!/bin/bash

set -ex

source_dir="$(dirname "$(readlink -f "${0}")")"
source "${source_dir}/latest_gh_release.sh"

version="$(latest_gh_release "leanprover/lean")"

if [[ -d /opt/lean ]]; then
  sudo mv /opt/lean /opt/lean.backup
fi
sudo mkdir /opt/lean
curl -Lo - "https://github.com/leanprover/lean/releases/download/${version}/lean-${version#v}-linux.tar.gz" \
  | sudo tar -C /opt/lean --strip-components=1 -xvzf -
if [[ -d /opt/lean.backup ]]; then
  sudo rm -rf /opt/lean.backup
fi
