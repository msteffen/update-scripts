#!/bin/bash

source_dir="$(dirname "$(readlink -f "${0}")")"
source "${source_dir}/add_to_file.sh"

set -e

sudo -n add-apt-repository ppa:jonathonf/vim
sudo -n apt-get update -y
sudo -n apt-get install -y vim

# Setup vimrc and make it your editor
curl https://raw.githubusercontent.com/msteffen/vimrc/master/setup.sh | bash -s -- vimrc
cmd='export EDITOR=vim'
desc='EDITOR export (set to vim)'
add_to_file "${cmd}" "${desc}" "${HOME}/.bashrc"
