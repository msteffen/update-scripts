#!/bin/bash
#
# This script installs the awscli v1. The current recommended version of the
# aws cli is v2, but I'm keeping this around for now in case some script or
# tool needs v1 for some reason. Note that the binary installed for awscli v2
# is called 'aws2', whereas this installs 'aws' so there is no name conflict

set -e

source_dir="$(dirname "$(readlink -f "${0}")")"
source "${source_dir}/add_to_file.sh"

# make sure python3 is installed
if ! python3 --version; then
  echo "Python3 must be installed" 
  exit 1
fi

# install pip vs easy_install rather than 'apt-get' so we can upgrade it
sudo -n python3 -m easy_install pip
pip3 install awscli --upgrade --user

# The install instructions say to add pip install location (${HOME}/.local/bin)
# to path, but all install scripts install there by default, and all assume
# that it's added to the path by ${HOME}/.bashrc (which, on Ubuntu, it is by
# default) so we skip that step in this script as well.
# See http://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html#awscli-install-linux-path
