#!/usr/bin/env bash -x

# file manipulation tools.

function err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

# https://stackoverflow.com/questions/7427262/how-to-read-a-file-into-a-variable-in-shell
function read_file() {
  if (($# < 1)); then
    err "please specify file path."
    return 1
  fi

  # shell can't return string directly, using `echo` instead.
  # https://stackoverflow.com/questions/8742783/returning-value-from-called-function-in-a-shell-script
  local ret=$(<$1)

  # trim whitespaces in leading and trailing
  # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
  echo $ret | xargs
}

# rename files with pattern in current directory.
# usage: rename $file_pattern $replacement
# refer-1, https://stackoverflow.com/questions/602706/batch-renaming-files-with-bash/602770#602770
# refer-2, https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
function batch_rename() {
  if (($# < 2)); then
    err "please specify file and replace patterns"
    return 1
  fi

  # file pattern
  local fileptn=$1

  # replacement
  local rpt=$2

  for i in $(find . -type f -name "*${fileptn}*"); do
    mv "$i" "${i/$fileptn/${rpt}}"
  done

}

# Get current directory's basename
# https://stackoverflow.com/questions/1371261/get-current-directory-name-without-full-path-in-a-bash-script
function bspwd() {
  echo "$(basename $PWD)"
}
