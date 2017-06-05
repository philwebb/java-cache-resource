#!/bin/sh

set -eu

_main() {

  # Used patched version until gh-120 is fixed
  # See https://github.com/concourse/git-resource/issues/120
  repo=https://github.com/philwebb/git-resource.git
  version=e6ab5771aaabfb75f71e3838eb172447ea022186

  tmpdir="$(mktemp -d git_resource_install.XXXXXX)"
  cd "$tmpdir"
  git clone "${repo}" .
  git checkout "${version}"
  mkdir -p /opt/resource/git
  cp -r assets/* /opt/resource/git
  chmod +x /opt/resource/git/*
}

_main "$@"
