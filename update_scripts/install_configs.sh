#!/bin/bash

source_dir="$(dirname "${0}")"
source "${source_dir}/add_to_file.sh"

set -e

# setup ~/bin
[[ -d ${HOME}/bin ]] || mkdir ${HOME}/bin
[[ ${PATH} =~ /home/.*/bin ]] || export PATH=${HOME}/bin:${PATH} # already in ubuntu .bashrc

# fix screen
export LOCKPRG=asdf
cmd='export LOCKPRG=true'
desc='LOCKPRG export (prevent screen from locking)'
add_to_file "${cmd}" "${desc}" "${HOME}/.bashrc"
touch ${HOME}/.screenrc
grep -q "escape ^Oo" ${HOME}/.screenrc || echo 'escape ^Oo' >>${HOME}/.screenrc
grep -q "bind x" ${HOME}/.screenrc || echo 'bind x' >>${HOME}/.screenrc

# Setup vimrc and make it your editor
curl https://raw.githubusercontent.com/msteffen/vimrc/master/setup.sh | bash -s -- vimrc
cmd='export EDITOR=vim'
desc='EDITOR export (set to vim)'
add_to_file "${cmd}" "${desc}" "${HOME}/.bashrc"
