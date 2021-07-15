#!/bin/bash

set -ex

source_dir="$(dirname "$(readlink -f "${0}")")"
source "${source_dir}/latest_gh_release.sh"

sudo -n echo starting || { echo -e "need sudo privileges. Run\nsudo echo test"; exit 1; }

if [[ -z "$( which jq )" ]]; then
  echo -e "Error: must install 'jq'. Run:\n  sudo apt install jq"
  exit 1
fi

if [[ -z "${VERSION}" ]]; then
  # Get latest goreleaser release
  VERSION="$(latest_gh_release "goreleaser/goreleaser")"
fi

echo "Getting latest goreleaser release (${VERSION})"
wget -q -O - --show-progress "https://github.com/goreleaser/goreleaser/releases/download/v${VERSION}/goreleaser_Linux_x86_64.tar.gz" \
  | sudo tar -C /usr/local/bin -xz goreleaser \
  && sudo chmod +x /usr/local/bin/goreleaser
