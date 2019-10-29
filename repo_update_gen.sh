#!/usr/bin/env bash -x
#
# Generate `update.sh` for repos under given folder.
# The content is like:
# "(cd /<sub-dir> && git pull)" 

# TODO: refactor
# print out error messages along with time information and arguments
# refer, https://google.github.io/styleguide/shell.xml
function err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

# https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Bourne-Shell-Builtins
function no_op() {
  : # no operation
}

# create update.sh under given folder which is first argument
function gen_repo_update_sh() {
  if (( $# < 1 )); then
    err "please specify root dir."
    return
  fi 

  local abspath=$(realpath $1)
  if [[ ! -d ${abspath} ]]; then
    err "given path - ${abspath} - is not a dir."
    return
  fi

  local update_sh="${abspath}/update.sh"
  if [[ -f "$update_sh" ]]; then
    err "update.sh already exists."
    return
  fi

  touch "${update_sh}"

  echo "#!/bin/bash\n" >> "${update_sh}"

  for file in "${abspath}"/* ; do
    if [[ -d "${file}" ]]; then
      local escaped_fp=$(printf '%q' "${file}")
      local file_basename=$(basename "${file}")

      echo "echo \"update => ${file_basename}\"" >> "${update_sh}"
      echo "( cd ${escaped_fp} && git pull --all )\n" >> "${update_sh}"
      echo "echo \"\"" >> "${update_sh}"
    fi
  done

  chmod +x "${update_sh}"
}
