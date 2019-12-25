#!/usr/bin/env bash

function test_case() {
  set -x

  case "$1" in
    . | ./*)
      echo "match dot"
      ;;
    \. | \./*)
      echo "match escaped dot"
      ;;
    *)
      echo "not match dot"
      ;;
  esac

  set +x
}
