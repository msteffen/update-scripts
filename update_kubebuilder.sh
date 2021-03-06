#!/bin/bash

set -e

source_dir="$(dirname "$(readlink -f "${0}")")"
source "${source_dir}/add_to_file.sh"
source "${source_dir}/latest_gh_release.sh"

####
# Parse flags
####

# Default values
version="$(latest_gh_release "kubernetes-sigs/kubebuilder")"
destination_str='${HOME}/.local' # will be eval'ed, letting callers use e.g. $HOME

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
          destination_str="${2}"
          shift 2
          ;;
        --)
          shift
          break
          ;;
    esac
done

os=$(go env GOOS)
arch=$(go env GOARCH)

# download kubebuilder and extract it to tmp
destination="$(eval "cd \"${destination_str}\"" && pwd)"
echo "Downloading kubebuilder for ${os}/${arch}, version ${version}"
curl -sL https://go.kubebuilder.io/dl/${version}/${os}/${arch} | tar -xz -C /tmp
mv "/tmp/kubebuilder_${version}_${os}_${arch}" "${destination}/kubebuilder"
chmod +x "${destination}/kubebuilder/bin/kubebuilder"

# (you'll need to set the KUBEBUILDER_ASSETS env var if you put it somewhere else)
cmd="export KUBEBUILDER_ASSETS=\"${destination_str}/kubebuilder\""
desc='KUBEBUILDER_ASSETS export'
add_to_file "${cmd}" "${desc}" "${HOME}/.profile"

cmd="export PATH=\"\${PATH}:${destination_str}/kubebuilder/bin\""
desc='PATH export'
add_to_file "${cmd}" "${desc}" "${HOME}/.profile"
