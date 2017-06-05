#!/bin/bash
set -e

. "$(dirname "$0")/helpers.sh"

it_has_installed_git_lfs() {
  git lfs env
}

it_cleans_up_installation_artifacts() {
  test ! -d git_lfs_install*
}

it_has_installed_java() {
  java -version
}

run it_has_installed_git_lfs
run it_cleans_up_installation_artifacts
run it_has_installed_java
