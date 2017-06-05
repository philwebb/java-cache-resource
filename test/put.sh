#!/bin/bash
set -e

source $(dirname $0)/helpers.sh

# tests

it_put_is_noop() {
  local repo=$(init_repo)
  local src=$(mktemp -d $TMPDIR/put-src.XXXXXX)
  result=`put_uri $repo $src repo`
  if [ ! -z $result ]; then
    exit 1;
  fi
}

# helpers

put_uri() {
  jq -n "{
    source: {
      uri: $(echo $1 | jq -R .),
      branch: \"master\"
    },
    params: {
      repository: $(echo $3 | jq -R .)
    }
  }" | ${resource_dir}/out "$2" || echo "exit with $?"
}

# test suite

run it_put_is_noop
