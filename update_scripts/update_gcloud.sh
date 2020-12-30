#!/bin/bash

set -ex

# Lookup latest version here: https://cloud.google.com/sdk/docs/#linux
GCLOUD_VERSION=224.0.0

echo "Making backup"
mv "${HOME}/.local/bin/google-cloud-sdk" "${HOME}/.local/bin/google-cloud-sdk.backup" || true

curl -Lo - "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz" \
  | tar -C "${HOME}/.local/bin" -xzf -

exec "${HOME}/.local/bin/google-cloud-sdk/install.sh"
rm -rf "${HOME}/.local/bin/google-cloud-sdk.backup"
