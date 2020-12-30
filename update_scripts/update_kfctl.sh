#!/bin/bash

set -ex

download_url="$(
  curl https://api.github.com/repos/kubeflow/kubeflow/releases \
    | jq -r '
        [ .[] | select(.tag_name | test("-rc") | not) ]
          | .[0].assets[]
          | select(.name | test("linux"))
          | .browser_download_url
    '
)"

curl -L "${download_url}" \
  | tar -C "${HOME}/bin" -xvzf - "./kfctl"

chmod +x "${HOME}/bin/kfctl"
