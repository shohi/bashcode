#!/usr/bin/env bash

#######################################################################
#                           array examples                            #
#######################################################################
function test_index() {
  aa=("aa" "bb" "cc")

  for i in "${!aa[@]}"; do
    echo "key :" $i
    echo "value:" ${aa[$i]}
  done
}

# refer, https://www.linuxjournal.com/content/bash-associative-arrays
# NOTE: associative array only available for `bash>=4.0`
function test_associative() {
  if (( BASH_VERSINFO[0] < 3 )); then
    echo "Sorry, you need at least bash-4.0 to run this script."
    return
  fi

  declare -A array
  array[hello]="world"
  array[key]="value"

  for i in "${!array[@]}"
  do
    echo "key :" $i
    echo "value:" ${array[$i]}
  done
}

# use `bash array.sh` or `bash -s < array.sh` to run tests in bash.
test_index
