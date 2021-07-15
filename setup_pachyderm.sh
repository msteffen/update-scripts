
set -e

source_dir="$(dirname "$(readlink -f "${0}")")"
source "${source_dir}/add_to_file.sh"

# Install pachyderm + pachctl
# This isn't always what I want.
echo "Do you want to download pachyderm under your go path? (y/N)"
echo "Path would be: \"${GOPATH}/src/github.com/pachyderm/pachyderm)?\""
read resp
if [[ "$( echo "${resp:0:1}" | tr '[:upper:]' '[:lower:]' )" =~ y ]]; then
  echo "Running 'go get github.com/pacyderm/pachyderm'..."
  pushd ${GOPATH}
  go get github.com/pachyderm/pachyderm
  cd ./src/github.com/pachyderm/pachyderm
  make install
  go install ./src/testing/match
  popd
else
  echo "Skipping 'go get github.com/pacyderm/pachyderm'..."
fi

# Install alias
add_to_file 'alias pc=pachctl' 'pachctl <-> pc alias' "${HOME}/.bash_aliases"

# because we need to run the batch test suite with sudo, we need to make sure
# a few binaries are in the secure path
[[ -e /usr/local/bin/aws ]] || sudo -n ln -s `which aws` /usr/local/bin/aws
[[ -e /usr/local/bin/go ]] || sudo -n ln -s `which go` /usr/local/bin/go

