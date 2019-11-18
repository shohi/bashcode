#!/usr/bin/env bash -x

# requires jq -> http://stedolan.github.io/jq/
# refer-1, https://gist.github.com/leogaggl/46d17ec9f91158a24ab8b05ef5e6bfb4
# refer-2, https://gist.github.com/joemiller/2dd72670e37769cb647c

# TODO
# 1. create workding dir if not exits
# 2. add FILTER args
# 3. use search api instead

# optional change working_dir
working_dir=${1-$(pwd)}
cd $working_dir

if [ -z "$TOKEN" ]; then
  echo "no TOKEN= environment var specified"
  exit 1
fi

if [ -z "$ORG" ]; then
  echo "no ORG= environment var specified"
  exit 1
fi

echo "==> Cloning all repos from '$ORG'"
# user="github_username"
# https://api.github.com/orgs/$organization/repos?type=private\&per_page=100 -u ${user}:${token}
query="https://api.github.com/orgs/$ORG/repos?per_page=500&type=private"

# NOTE: need pagination
repo_list=$(curl -u "$TOKEN:x-oauth-basic" -s "$query" | jq --arg v "$TEST" '.[] | select(.name | test($v)) | .ssh_url' | sed -e 's/^"//'  -e 's/"$//')

for repo in $repo_list
do

  echo "Repo found: $repo"
  git clone $repo
done
