function latest_gh_release {
  repo="${1}"

  # Note: prefer 'sed -n 1p' over 'head -n 1' because sed reads its entire input
  # before closing its input pipe, avoiding the curl error:
  #   "curl: (23) Failed writing body (580 != 1387)"
  echo "$(
    curl -sL "https://api.github.com/repos/${repo}/releases" \
      | jq -r '.[].tag_name' \
      | grep -v 'alpha\|beta\|rc' \
      | sort -r --version-sort \
      | sed -n '1p' \
      | sed 's/^v//'
  )"
}
