#!/usr/bin/env bash -x

#######################################################################
#                      Utilities for docker image                     #
#######################################################################

GCR_MIRROR="gcr.azk8s.cn"
K8S_GCR_MIRROR="gcr.azk8s.cn/google-containers"

# check whether given images already exist locally.
# https://stackoverflow.com/questions/30543409/how-to-check-if-a-docker-image-with-a-specific-tag-exist-locally
function _image_exist() {
  if [[ "$(docker images -q "$1" 2>/dev/null)" == "" ]]; then
    return 1
  else
    return 0
  fi
}

# https://stackoverflow.com/questions/1527049/how-can-i-join-elements-of-an-array-in-bash
function join_by() {
  local IFS="$1"
  shift
  echo "$*"
}

function _replace_registry() {
  local img=$1
  local original=$2
  local replace=$3

  # arr=(${img//\// })                        # in zsh, it's not a array.
  # arr=$(IFS='/' read -r -a ADDR <<< "$IN")  # on macOS, `-a` is bad option.
  local sep="/"
  local arr=($(echo "$img" | tr "${sep}" '\n'))
  if ((${#arr[@]} < 2)); then
    echo "ERR: image name should be \"${original}/xxx/yyy\"."
    return
  fi

  local reg=${arr[1]}
  if [ "$reg" != "${original}" ]; then
    echo "ERR: image name should start with \"${original}\"."
    return
  fi

  # new image name
  arr[1]=${replace}
  local ng=$(join_by "${sep}" "${arr[@]}")

  echo ${ng} | xargs
}

# docker pull images for gcr.io and k8s.gcr.io using mirror registry.
# image url from `gcr.io` will be replaced by the coresponding one using
# the mirror registry, e.g.
# `docker pull gcr.io/k8s-minikube/storage-provisioner:v1.8.1``
# will be replaced by following.
# `docker pull ${GCR_MIRROR}/k8s-minikube/storage-provisioner:v1.8.1``
# After image successfully downloaded, original name will be used while the mirror
# one will be removed.
function _docker_pull_from_mirror() {
  if $(_image_exist "$1"); then
    return
  fi

  local img=$1
  local new_img=$(_replace_registry "$@")

  if [ -z "${new_img}" ] || [[ "${new_img}" == "ERR"* ]]; then
    return 1
  fi

  docker pull ${new_img}
  if [ $? -ne 0 ]; then
    echo "pull image failed - ${new_img}"
    return 1
  else
    docker tag ${new_img} ${img}
    docker rmi ${new_img}
  fi
}

function dp_gcr() {
  if (($# < 1)); then
    echo "image should be provided."
    return 1
  fi

  _docker_pull_from_mirror "$1" "gcr.io" "${GCR_MIRROR}"
}

# docker pull images for k8s.gcr.io
function dp_k8s_gcr() {
  if (($# < 1)); then
    echo "image should be provided."
    return 1
  fi

  _docker_pull_from_mirror "$1" "k8s.gcr.io" "${K8S_GCR_MIRROR}"
}

# images used by minikube
function minikube_provision() {
  local images=$(
    cat <<HEREDOC
    gcr.io/k8s-minikube/storage-provisioner:v1.8.1
    k8s.gcr.io/kube-addon-manager:v9.0.2
    k8s.gcr.io/coredns:1.6.2
    k8s.gcr.io/kube-addon-manager:v9.0
    k8s.gcr.io/kube-controller-manager:v1.16.2
    k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1
    k8s.gcr.io/kube-scheduler:v1.16.2
    k8s.gcr.io/pause:3.1
    k8s.gcr.io/kube-proxy:v1.16.2
    k8s.gcr.io/kube-apiserver:v1.16.2
    k8s.gcr.io/etcd:3.3.15-0
    k8s.gcr.io/k8s-dns-dnsmasq-nanny-amd64:1.14.13
    k8s.gcr.io/k8s-dns-sidecar-amd64:1.14.13
    k8s.gcr.io/k8s-dns-kube-dns-amd64:1.14.13
HEREDOC
  )

  local arr=($(echo "${images}" | tr "" '\n'))
  echo "start downloading docker images used by minikube..."
  for i in "${arr[@]}"; do
    echo "=> $i"
    case "$i" in
      "gcr.io"*)
        dp_gcr "$i"
        ;;

      "k8s.gcr.io"*)
        dp_k8s_gcr "$i"
        ;;

      *)
        echo "image is not started with 'gcr.io' or 'k8s.gcr.io' - $i"
        ;;
    esac
  done
}
