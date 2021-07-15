#!/bin/bash

set -e

source_dir="$(dirname "$(readlink -f "${0}")")"
source "${source_dir}/add_to_file.sh"

sudo apt install -y "direnv"
sudo apt upgrade -y

# Add direnv to bashrc
cmd='eval "$(direnv hook bash)"'
desc='direnv hook'
add_to_file "${cmd}" "${desc}" "${HOME}/.bashrc"
