#!/usr/bin/env bash -x

#######################################################################
#                        kubernetes utilities                         #
#######################################################################

# remove pod which matches given pattern
#
# Usage: kube_rmpo $pod_pattern
function kube_rmpo() {
  local ptn=$1
  local pods
  if [ -z "$ptn" ]; then
    echo "pod pattern must not be empty."
    return 1
  fi
  pods=$(kubectl get pods | grep "$ptn" | awk '{print $1}')

  for i in "$pods[@]"; do
    if [ -n "$BASH_VERSION" ]; then
      read -p "delete pod - $i (y/n)? " yn
    else
      # default zsh
      vared -p "delete pod - $i (y/n)? " -c yn
    fi

    case "$yn" in
      [yY]*)
        kubectl delete pod "$i"
        ;;
      *)
        continue
        ;;
    esac
  done
}
