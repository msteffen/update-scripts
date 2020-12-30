#!/bin/bash

function must_have_pkg {
  { dpkg -l | grep "${1}"; } || {
    echo "error: Missing package $1"
    exit 1
  }
}

set -e

vim -c ":PluginUpdate" -c ":qa"
must_have_pkg build-essential
must_have_pkg cmake
must_have_pkg python-dev
must_have_pkg python3-dev
cd ~/.vim/bundle/YouCompleteMe || { echo "Could not find ~/.vim/bundle/YouCompleteMe"; exit 1; }
./install.py
