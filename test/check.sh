#!/bin/bash
set -e

source $(dirname $0)/helpers.sh

# tests

it_can_check_from_head() {
  local repo=$(init_repo)
  local ref=$(make_commit $repo)
  check_uri $repo | jq -e "
    . == [{ref: $(echo $ref | jq -R .)}]
  "
}

it_checks_given_glob_paths() { # issue gh-120
  local repo=$(init_repo)
  mkdir -p $repo/a/b
  local ref1=$(make_commit_to_file $repo a/file)
  local ref2=$(make_commit_to_file $repo a/b/file)
  local ref3=$(make_commit_to_file $repo foo)
  check_uri_paths $repo "**/file" | jq -e "
    . == [{ref: $(echo $ref2 | jq -R .)}]
  "
}

it_ignores_given_glob_paths_when_force_version() { # issue gh-120
  local repo=$(init_repo)
  mkdir -p $repo/a/b
  local ref1=$(make_commit_to_file $repo a/file)
  local ref2=$(make_commit_to_file $repo a/b/file)
  local ref3=$(make_commit_to_file $repo foo)
  check_uri_paths_with_force_version $repo "**/file" | jq -e "
    . == [{ref: $(echo $ref3 | jq -R .)}]
  "
}

# helpers

check_uri() {
  jq -n "{
    source: {
      uri: $(echo $1 | jq -R .)
    }
  }" | ${resource_dir}/check | tee /dev/stderr
}

check_uri_paths() {
  local uri=$1
  shift
  jq -n "{
    source: {
      uri: $(echo $uri | jq -R .),
      paths: $(echo "$@" | jq -R '. | split(" ")')
    }
  }" | ${resource_dir}/check | tee /dev/stderr
}

check_uri_paths_with_force_version() {
  local uri=$1
  shift
  jq -n "{
    source: {
      uri: $(echo $uri | jq -R .),
      paths: $(echo "$@" | jq -R '. | split(" ")')
    },
    version: {
      ref: \"force\"
    }
  }" | ${resource_dir}/check | tee /dev/stderr
}

# test suite

run it_can_check_from_head
run it_checks_given_glob_paths
run it_ignores_given_glob_paths_when_force_version
