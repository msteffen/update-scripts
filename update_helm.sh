#!/bin/bash

set -e

source_dir="$(dirname "$(readlink -f "${0}")")"
source "${source_dir}/add_to_file.sh"
source "${source_dir}/latest_gh_release.sh"

####
# Parse flags
####

# Default values
version="$(latest_gh_release "helm/helm")"
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

set -x
curl -sL https://get.helm.sh/helm-v${version}-linux-amd64.tar.gz \
  | tar -xvz --strip-components=1 -C "${destination}" linux-amd64/helm
