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
  if (($# < 1)); then
    echo "please specify path"
    return 1
  fi

  local p=$1

  case "$p" in
    / | /*)
      printf "%s" "$p"
      return
      ;;

    . | ./* | .. | ../*)
      # split
      # NOTE: zsh not support ('a b c') to array
      # arr=(${p//\// })
      arr=($(echo -e "${p//\//\n}" | awk '{print $1}'))
      # echo "arr => ${arr[@]} ${#arr[@]}"

      local tdir=$PWD
      if [ ".." = "${arr[@]:0:1}" ]; then
        tdir=$(cd .. &>/dev/null && printf "%s" "$PWD")
      fi
      local sarr=(${arr[@]:1})
      local tstr="${sarr[*]}"
      local jstr="${tstr// //}"

      printf "%s/%s" "${tdir}" "${jstr}"
      return
      ;;

    *)
      printf "%s" "$p"
      return 1
      ;;
  esac
}
