#!/bin/bash

set -e

source_dir="$(dirname "$(readlink -f "${0}")")"
source "${source_dir}/add_to_file.sh"

####
# Parse flags
####

# Default values
version="$(
  curl -sL https://api.github.com/repos/aws/aws-cli/releases \
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

echo "Creating /tmp/awscliv2.zip and /tmp/aws"
echo "You'll need to clean up that file if this script fails"

curl -sLo "/tmp/awscliv2.zip" \
  "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${version}.zip" 
cd /tmp
unzip awscliv2.zip

# the AWS CLI v2 comes with its own simple installer, so use that, but keep
# everything under ~/.local (so no sudo is needed). Also, pass the --update
# flag so that this updates an existing install if one is present (by default
# it errors).
#
# TODO: I can't figure out how to prevent this script from being interactive.
# It prompts if an update is necessary, and piping 'yes' to it doesn't work
# somehow?
yes | ./aws/install \
  --update \
  --install-dir "${HOME}/.local/aws-cli" \
  --bin-dir "${HOME}/.local/bin"

# Clean up files in /tmp
rm -rf /tmp/awscliv2.zip /tmp/aws
echo "Files under /tmp have been cleaned up...phew"\!
