#!/bin/bash

# To download a version directly:
# $ curl -Lo - https://github.com/etcd-io/etcd/releases/download/v3.3.10/etcd-v3.3.10-linux-amd64.tar.gz | tar -xvzf - /etcd-v3.3.10-linux-amd64/etcdctl
# $ chmod +x etcd-v3.3.10-linux-amd64/etcdctl
# $ mv etcd-v3.3.10-linux-amd64/etcdctl ${HOME}/bin # or somewhere on $PATH

set -e

source_dir="$(dirname "${0}")"
source "${source_dir}/add_to_file.sh"

####
# Parse flags
####

# Default values
version="$(
  curl https://api.github.com/repos/etcd-io/etcd/releases \
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

curl -Lo - "https://github.com/etcd-io/etcd/releases/download/v${version}/etcd-v${version}-linux-amd64.tar.gz" \
  | tar -xvz --strip-components=1 -C "${destination}" "etcd-v${version}-linux-amd64/etcdctl"
chmod +x "${destination}/etcdctl"