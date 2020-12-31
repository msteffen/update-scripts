#!/bin/bash

sudo apt install -y "direnv"
sudo apt upgrade -y

# Add direnv to bashrc
echo "Maybe adding direnv hook to ${HOME}/.bashrc"
cmd='eval "$(direnv hook bash)"'
grep -q --fixed-strings "${cmd}" "${HOME}/.bashrc"&& {
  echo "${HOME}/.bashrc is unchanged"
} || {
  echo -e "\n${cmd}" >>"${HOME}/.bashrc"
  echo "added direnv hook to ${HOME}/.bashrc"
}
