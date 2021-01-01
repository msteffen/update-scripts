function add_to_file {
  # Parse flags
  # ---
  # This is somewhat involved b/c we want to fail if getopt fails. Turns out
  #   local x="$(false)" || return 1
  # doesn't work, but
  #   local x; x="$(false)" || return 1
  # does. (also 'eval "x=$(false)"' loses the exit code, but only b/c
  # 'false' runs before 'eval')
  # ---
  local new_args
  new_args="$( set -e; getopt -l 'use-sudo' -- 'add_to_file' "${@}")" \
    || return 1 # fail on any error from getopt (unrecogonized arguments)
  eval "new_args=( ${new_args} )"  # split into bash array
  if [[ "${new_args[0]}" == --use-sudo ]]; then
    local use_sudo=true
    new_args=( "${new_args[@]:1}" )
  fi
  new_args=( "${new_args[@]:1}" )  # drop the "--"

  # Get positional arguments
  if [[ "${#new_args[@]}" -ne 3 ]]; then
    echo "Need three arguments: command, description, and file" >/dev/stderr
    echo "Got: ${@}" >/dev/stderr
    return 1
  fi
  local cmd="${new_args[0]}"
  local desc="${new_args[1]}"
  local file="${new_args[2]}"

  # Start
  echo -n "Maybe adding '${desc}' to '${file}'..."

  # Grep ${file} for ${cmd}
  if grep --fixed-strings -q "${cmd}" "${file}"; then
    echo "'${desc}' is already present; leaving '${file}' unchanged"
    return
  fi

  # Add ${cmd} to ${file}
  if [[ "${use_sudo}" ]]; then
    # Use tee rather than bash's '>>', so writing happens in sudo's subshell
    echo -e "\n${cmd}" | sudo -n tee -a "${file}" >/dev/null
  else
    echo -e "\n${cmd}" >>"${file}"
  fi
  echo "added '${desc}' to '${file}'"
}
