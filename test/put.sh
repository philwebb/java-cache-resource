#!/bin/bash
set -e

source $(dirname $0)/helpers.sh

it_put_is_noop() {
  local repo=$(init_repo)
  local src=$(mktemp -d $TMPDIR/put-src.XXXXXX)
  result=`put_uri $repo $src repo`
  if [ ! -z $result ]; then
    exit 1;
  fi
}

run it_put_is_noop
