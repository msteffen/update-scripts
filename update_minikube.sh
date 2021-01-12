#!/bin/bash

set -e

source_dir="$(dirname "${0}")"
source "${source_dir}/add_to_file.sh"

####
# Parse flags
####

# Default values
version="$(
  curl -sL https://api.github.com/repos/kubernetes/minikube/releases \
    | jq -r '.[].tag_name' \
    | grep -v 'alpha\|beta\|rc' \
    | sort -r --version-sort \
    | sed -n '1p' \
    | sed 's/^v//'
)"
destination="${HOME}/.local/bin"

# Run getopt in definition (rather than inline in 'eval') so that an error
# (e.g. unrecognized argument) causes the script to exit.
newargs="$( getopt -l "version:,destination:" "--" "${0}" "${@:-}" )"
eval "set -- ${newargs}"
while true; do
    case "${1}" in
        --version)
          version="${2#v}"
          shift 2
          ;;
        --destination)
          destination="${2}"
          shift 2
          ;;
        --)
          shift
          break
          ;;
    esac
done

curl -L -o "${destination}/minikube" "https://storage.googleapis.com/minikube/releases/v${version}/minikube-linux-amd64"
chmod +x "${destination}/minikube"
