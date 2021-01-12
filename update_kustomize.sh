#!/bin/bash

set -e

source_dir="$(dirname "${0}")"
source "${source_dir}/add_to_file.sh"

####
# Parse flags
####

# Default values
version="$(
  # Kustomize releases use weird tag names (because there are multiple
  # different release types happening in the same repo), so select only
  # 'kustomize' releases and remove the prefix
  curl -sL https://api.github.com/repos/kubernetes-sigs/kustomize/releases \
    | jq -r '.[].tag_name' \
    | grep kustomize \
    | sed 's#kustomize/v##' \
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

curl -sL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${version}/kustomize_v${version}_linux_amd64.tar.gz \
  | tar -xvz -C "${destination}" "kustomize"
chmod +x "${destination}/kustomize"
