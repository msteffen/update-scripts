#!/bin/bash

set -ex

sudo -n apt-get install apt-transport-https ca-certificates gnupg

# Add gcloud PPK to apt sources
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
  | sudo -n tee /etc/apt/sources.list.d/google-cloud-sdk.list

# Download Google cloud public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
  | sudo -n apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Install google cloud SDK
sudo apt-get update && sudo apt-get install google-cloud-sdk
