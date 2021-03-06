#!/bin/bash

# To download a version directly:
# $ curl -Lo - https://github.com/etcd-io/etcd/releases/download/v3.3.10/etcd-v3.3.10-linux-amd64.tar.gz | tar -xvzf - /etcd-v3.3.10-linux-amd64/etcdctl
# $ chmod +x etcd-v3.3.10-linux-amd64/etcdctl
# $ mv etcd-v3.3.10-linux-amd64/etcdctl ${HOME}/bin # or somewhere on $PATH

set -e

source_dir="$(dirname "$(readlink -f "${0}")")"
source "${source_dir}/add_to_file.sh"
source "${source_dir}/latest_gh_release.sh"

####
# Parse flags
####

# Default values
version="$(latest_gh_release "etcd-io/etcd")"
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

curl -sL "https://github.com/etcd-io/etcd/releases/download/v${version}/etcd-v${version}-linux-amd64.tar.gz" \
  | tar -xvz --strip-components=1 -C "${destination}" "etcd-v${version}-linux-amd64/etcdctl"
chmod +x "${destination}/etcdctl"
