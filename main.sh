#!/usr/bin/env bash -x

#######################################################################
#                              main entry                             #
#######################################################################

# NOTE: SHOULD change directory to current folder first, ohterwise
# scripts can't be found and loaded.

function main() {
  # TODO: refactor, use glob to process all scripts under `scripts` folder.
  local scripts=("file.sh" "dir.sh" "repo.sh" "image.sh" "datetime.sh")
  for s in "${scripts[@]}"; do
    if [[ -f "scripts/$s" ]]; then
      source "scripts/$s"
    else
      echo "[%s] not found in scripts folder"
    fi
  done
}

# NOTE: "$@" is for advanced features which may be developed in the future.
# Currently, it takes no effect.
main "$@"
