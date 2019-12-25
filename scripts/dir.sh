#!/usr/bin/env bash -x

# frequently used dir maninpulation functions.

# create dir using current date as name, e.g `2019-11-11`.
function mkdir_today() {
  mkdir -p $(date '+%Y-%m-%d')
}

# create dir using current date as name, e.g `19-11-11`.
function mkdir_today_short() {
  mkdir -p $(date '+%y-%m-%d')
}

# cd to foler whose name is current day, e.g `2019-11-11`.
function cd_today() {
  local td="$(date '+%Y-%m-%d')"
  if [[ -d "${td}" ]]; then
    cd "$td"
  else
    echo "no directory found - ${td}"
  fi
}

# TODO: fix resolve relative path
# https://unix.stackexchange.com/questions/24293/converting-relative-path-to-absolute-path-without-symbolic-link
function abs_path() {
  (cd "$(dirname '$1')" &>/dev/null && printf "%s/%s" "$PWD" "${1##*/}")
}
