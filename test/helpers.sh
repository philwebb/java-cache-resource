#!/bin/bash
set -e -u
set -o pipefail

export TMPDIR_ROOT=$(mktemp -d /tmp/java-cache-resource-tests.XXXXXX)
trap "rm -rf $TMPDIR_ROOT" EXIT

if [ -d /java-cache-resource/assets ]; then
  resource_dir=/java-cache-resource/assets
elif [ -d /opt/resource ]; then
  resource_dir=/opt/resource
else
  resource_dir=$(cd $(dirname $0)/../assets && pwd)
fi

test_dir=$(cd $(dirname $0) && pwd)

run() {
  export TMPDIR=$(mktemp -d ${TMPDIR_ROOT}/run.XXXXXX)

  echo -e 'running \e[33m'"$@"$'\e[0m...'
  eval "$@" 2>&1 | sed -e 's/^/  /g'
  echo ""
}

init_repo() {
  (
    set -e
    cd $(mktemp -d $TMPDIR/repo.XXXXXX)
    git init -q
    # start with an initial commit
    git \
      -c user.name='test' \
      -c user.email='test@example.com' \
      commit -q --allow-empty -m "init"
    # create some bogus branch
    git checkout -b bogus
    git \
      -c user.name='test' \
      -c user.email='test@example.com' \
      commit -q --allow-empty -m "commit on other branch"
    # back to master
    git checkout master
    # print resulting repo
    pwd
  )
}

make_commit() {
  make_commit_to_file $1 some-file "${2:-}"
}

make_commit_to_file() {
  make_commit_to_file_on_branch $1 $2 master "${3-}"
}

make_commit_to_file_on_branch() {
  local repo=$1
  local file=$2
  local branch=$3
  local msg=${4-}
  # ensure branch exists
  if ! git -C $repo rev-parse --verify $branch >/dev/null; then
    git -C $repo branch $branch master
  fi
  # switch to branch
  git -C $repo checkout -q $branch
  # modify file and commit
  echo x >> $repo/$file
  git -C $repo add $file
  git -C $repo \
    -c user.name='test' \
    -c user.email='test@example.com' \
    commit -q -m "commit $(wc -l $repo/$file) $msg"
  # output resulting sha
  git -C $repo rev-parse HEAD
}
