#!/usr/bin/env bash -x

# file manipulation tools.

function err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

# https://stackoverflow.com/questions/7427262/how-to-read-a-file-into-a-variable-in-shell
function read_file() {
  if (( $# < 1 )); then
    err "please specify file path."
    return
  fi

  # shell can't return string directly, using `echo` instead.
  # https://stackoverflow.com/questions/8742783/returning-value-from-called-function-in-a-shell-script
  local ret=$(<$1)

  # trim whitespaces in leading and trailing
  # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
  echo $ret | xargs
}
