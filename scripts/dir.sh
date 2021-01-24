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

# cd to folder whose name is current day, e.g `2019-11-11`.
function cd_today() {
  local td="$(date '+%Y-%m-%d')"
  if [[ -d "${td}" ]]; then
    cd "$td"
  else
    echo "no directory found - ${td}"
  fi
}

# cd to ~/Desktop/daily/[TODAY]
function cd_dd() {
  local dd="$HOME/Desktop/daily/$(date '+%Y-%m-%d')"
  mkdir -p "${dd}"
  cd "$dd"
}
# cd to ~/Desktop/tmp
function cd_tmp() {
  local dd="$HOME/Desktop/tmp"
  mkdir -p "${dd}"
  cd "$dd"
}

# cd to ~/Desktop
function cd_d() {
  local dd="$HOME/Desktop"
  cd "$dd"
}


# cd to `~/.emacs.d`
function cd_emacs() {
  local dd="$HOME/.emacs.d"
  if [[ -d "${dd}" ]]; then
    cd "$dd"
  else
    echo "no directory found - ${dd}"
  fi
}

# handle multiple levels relative path, e.g. "../../a/b/c"
# NOTE: only consecutive relatives are allowed,
# paht like "../bc/../de" can't be resolved.
function _resolve_multiple_relative() {
  local p=$1

  # split
  # NOTE: zsh not support ('a b c') to array
  # arr=(${p//\// })
  # arr=($(echo -e "${p//\//\n}" | awk '{print $1}'))
  local arr=($(echo -e "${p//\//\n}"))
  local tdir=${arr[@]:0:1}
  local tpwd=$PWD
  while [ ".." = "${arr[@]:0:1}" ]; do
    tpwd=$(cd "${tpwd}" && cd .. &>/dev/null && printf "%s" "$PWD")

    # remove first element
    arr=(${arr[@]:1})
    # echo "arr=> ${arr[@]}, ${#arr[@]}, ${arr[@]:0:1}"
  done

  local tstr="${arr[*]}"
  local jstr="${tstr// //}"

  printf "%s/%s" "${tpwd}" "${jstr}"
}

# convert given path to abs path
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
      ;;
    . | ./*)
      printf "%s" "${p/\./$PWD}"
      ;;
    .. | ../*)
      _resolve_multiple_relative "$p"
      ;;

    *)
      printf "%s" "$p"
      return 1
      ;;
  esac
}
