#!/bin/bash

source_dir="$(dirname "${0}")"
source "${source_dir}/add_to_file.sh"

set -e

# Default values
version="$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"
# version=v1.15.5 # latest version that works with kubeflow
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

# Get latest kubectl release
kc_tar_file=kubernetes-client-linux-amd64.tar.gz
echo "Getting latest kubectl release (${version})"
curl -L "https://storage.googleapis.com/kubernetes-release/release/${version}/${kc_tar_file}" \
  | tar -xvz --strip-components=3 -C "${destination}" "kubernetes/client/bin/kubectl"
chmod +x "${destination}/kubectl"

# Install alias
add_to_file 'alias kc=kubectl' 'kubectl <-> kc alias' "${HOME}/.bash_aliases"

