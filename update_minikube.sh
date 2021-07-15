#!/bin/bash

set -e

source_dir="$(dirname "$(readlink -f "${0}")")"
source "${source_dir}/add_to_file.sh"
source "${source_dir}/latest_gh_release.sh"

####
# Parse flags
####

# Default values
version="$(latest_gh_release "kubernetes/minikube")"
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
