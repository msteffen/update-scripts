#!/bin/bash

set -ex

# Parse flags
version=latest
eval "set -- $( getopt -l "version:" "--" "${0}" "${@:-}" )"
while true; do
    case "${1}" in
        --version)
          version="${2#v}"
          shift 2
          ;;
        --)
          shift
          break
          ;;
        *)
          echo "Unrecognized argument: \"${1}\""
          echo "Must be one of --state, --zone, --use-cloudfront, --no-pachyderm"
          exit 1
          ;;
    esac
done


os=$(go env GOOS)
arch=$(go env GOARCH)

# download kubebuilder and extract it to tmp
curl -sL https://go.kubebuilder.io/dl/${version}/${os}/${arch} | tar -xz -C /tmp/

# move to a long-term location and put it on your path
# (you'll need to set the KUBEBUILDER_ASSETS env var if you put it somewhere else)
if [[ -d /usr/local/kubebuilder ]]; then
  sudo rm -rf /usr/local/kubebuilder
fi
sudo mv /tmp/kubebuilder_${version}_${os}_${arch} /usr/local/kubebuilder
