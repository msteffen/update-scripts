#!/bin/bash

set -e

# Determine the most recent release of Go
echo "Downloading golang.org/dl"
LATEST_VERSION="$(
# Note: prefer 'sed -n 1p' over 'head -n 1' because sed reads its entire input
# before closing its input pipe, avoiding the curl error:
#   "curl: (23) Failed writing body (580 != 1387)"
curl -L golang.org/dl \
  | grep -E '"/dl/go([0-9]{1,3}\.){2,3}linux-amd64.tar.gz"' \
  | sed -n 1p \
  | sed 's#^.*"/dl/go\(\([0-9]\{1,3\}\.\)\{2,3\}\)linux-amd64.tar.gz".*$#\1#g' \
  | sed 's/.$//' \
)"
VERSION="${VERSION:-$LATEST_VERSION}"
if [[ -z "${VERSION}" ]]; then
  echo "could not determine latest version" >/dev/stderr
  exit 1
fi

if which go && [[ "$(go version | awk '{print $3}' | sed 's/^go//')" = "${VERSION}" ]]; then
  echo "Go is already at latest version ${VERSION}; exiting"
  exit 0
fi

# Figure out which version of Go to download based on the environment
case "$(uname -o)" in
  GNU/Linux)
    os="linux"
    ;;
  default)
    echo "Unrecognized os: \"$(uname -o)\"; exiting" >/dev/stderr
    exit 1
esac

case "$(uname -m)" in
  x86_64)
    arch="amd64"
    ;;
  default)
    echo "Unrecognized os: \"$(uname -o)\"; exiting" >/dev/stderr
    exit 1
esac

echo "Downloading go ${VERSION}"

if [[ -d /usr/local/go ]]; then
  echo "existing go installation found. Backing it up"
  if [[ -d /usr/local/go.old ]]; then
    echo "...doing so will overwrite the old backup at /usr/local/go.old"
    sudo -n rm -r /usr/local/go.old
  fi
  sudo mv /usr/local/go /usr/local/go.old
fi

# Download & unpack go binary
dir=$(mktemp -d /tmp/go_binary.XXXXXXX)
echo "Downloading https://storage.googleapis.com/golang/go${VERSION}.${os}-${arch}.tar.gz -> ${dir}/go${VERSION}.${os}-${arch}.tar.gz"
pushd ${dir}
curl -L -o go${VERSION}.${os}-${arch}.tar.gz https://storage.googleapis.com/golang/go${VERSION}.${os}-${arch}.tar.gz
echo "Unpacking binary to /usr/local (will create /usr/local/go)"
sudo tar -C /usr/local -xzf go${VERSION}.${os}-${arch}.tar.gz
echo "Unpacking finished"\!
popd

echo "removing ${dir}"
rm -rf ${dir}

# Set GOPATH on startup (must happen before PATH, as PATH includes it)
echo "Setting GOPATH in /etc/profile and ${HOME}/.bashrc"
cmd='export GOPATH="${HOME}/go"'
grep --fixed-strings -q "${cmd}" /etc/profile && {
  echo '/etc/profile GOPATH export is unchanged'
} || {
  # Use tee rather than bash's >> redirect so writing happens in sudo subshell
  echo -e "\n${cmd}" | sudo -n tee -a /etc/profile >/dev/null
  echo "added 'export GOPATH' to /etc/profile"
}
grep --fixed-strings -q "${cmd}" "${HOME}/.bashrc" && {
  echo "${HOME}/.bashrc GOPATH export is unchanged"
} || {
  echo -e "\n[[ -n \"\${GOPATH}\" ]] || ${cmd}" >>$HOME/.bashrc
  echo "added 'export GOPATH' to ${HOME}/.bashrc"
}

# Set PATH on startup (GOPATH must be set)
echo 'Updating /etc/profile and ${HOME}/.bashrc to point to new go binary and ${GOPATH}/bin'
cmd='export PATH="${PATH}:/usr/local/go/bin:${GOPATH}/bin"'
grep --fixed-strings -q "${cmd}" /etc/profile && {
  echo '/etc/profile PATH export is unchanged'
} || {
  echo -e "\n${cmd}" | sudo -n tee -a /etc/profile >/dev/null
  echo "added 'export PATH' to /etc/profile"
}

grep --fixed-strings -q "${cmd}" "${HOME}/.bashrc" && {
  echo "${HOME}/.bashrc PATH export is unchanged"
} || {
  echo -e "\n[[ \"\${PATH}\" =~ /usr/local/go/bin ]] || ${cmd}" >>"${HOME}/.bashrc"
  echo "added 'export PATH' to ${HOME}/.bashrc"
}

# Delete backed up go installation
[[ -d /usr/local/go.old ]] && sudo -n rm -r /usr/local/go.old
