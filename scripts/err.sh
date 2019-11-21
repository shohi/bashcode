#!/usr/bin/env bash -x
#
# utility functions

# print out error messages along with time information and arguments
# refer, https://google.github.io/styleguide/shell.xml
function err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}
