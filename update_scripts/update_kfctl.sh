#!/bin/bash

set -e

source_dir="$(dirname "$(readlink -f "${0}")")"
source "${source_dir}/latest_gh_release.sh"

# Default values
version="$(latest_gh_release "kubeflow/kfctl")"
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


# The kfctl release assets all have the release's git commit in their filename,
# but the github API doesn't expose that information, so use jq to list the
# assets and find the one we want to download
download_url="$(
  curl "https://api.github.com/repos/kubeflow/kfctl/releases/tags/v${version}" \
    | jq -r '.assets[] | select(.name | test("linux")) | .browser_download_url'
)"
curl -L "${download_url}" \
  | tar -C "${destination}" -xvz "./kfctl"

chmod +x "${destination}/kfctl"
