#!/bin/bash

####
# Parse flags
####

# Default values
version="$(
  # This S3 bucket seems to be where this tool (possibly among others) is
  # released
  aws s3 ls 's3://amazon-eks' \
    | awk '{print $2}' \
    | grep -E '([0-9]+\.){2,3}[0-9]+' \
    | sed 's:/$::' \
    | sort -r --version-sort \
    | sed -n '1p'
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

# release_date appears to be part of the path. There only seems to be one date
# in each version directory, though, so this script just looks them up.
release_date="$(
  aws s3 ls "s3://amazon-eks/${version}/" \
    | awk '{print $2}' \
    | sed -n '1p' \
    | sed 's:/$::'
)"
aws s3 cp \
  "s3://amazon-eks/${version}/${release_date}/bin/linux/amd64/aws-iam-authenticator" \
  "${destination}/aws-iam-authenticator"
chmod +x "${destination}/aws-iam-authenticator"
