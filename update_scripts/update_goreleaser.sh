#!/bin/bash

set -ex

sudo -n echo starting || { echo -e "need sudo privileges. Run\nsudo echo test"; exit 1; }

if [[ -z "$( which jq )" ]]; then
  echo -e "Error: must install 'jq'. Run:\n  sudo apt install jq"
  exit 1
fi

if [[ -z "${VERSION}" ]]; then
  # Get latest goreleaser release
  VERSION="$(
    curl -s https://api.github.com/repos/goreleaser/goreleaser/releases \
      | jq -r '.[].name' \
      | sed 's/^v//' \
      | grep -Ev 'alpha|beta|rc' \
      | sort --version-sort \
      | tail -n 1
  )"
fi

echo "Getting latest goreleaser release (${VERSION})"
wget -q -O - --show-progress "https://github.com/goreleaser/goreleaser/releases/download/v${VERSION}/goreleaser_Linux_x86_64.tar.gz" \
  | sudo tar -C /usr/local/bin -xz goreleaser \
  && sudo chmod +x /usr/local/bin/goreleaser
