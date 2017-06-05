#!/bin/bash
set -e

not_installed() {
  ! command -v $1 > /dev/null 2>&1
}

if not_installed docker; then
  echo "# docker is not installed! run the following commands:"
  echo "    brew install docker"
  echo "    brew cask install docker-machine"
  echo "    docker-machine create dev --driver virtualbox"
  echo '    eval $(docker-machine env dev)'
  echo "    docker login"
  exit 1
fi

resource_dir=$(cd $(dirname $0)/.. && pwd)
cd "${resource_dir}"
docker build -t springio/java-cache-resource .

docker run -v "${resource_dir}:/java-cache-resource" \
    -it \
    -w /java-cache-resource \
    springio/java-cache-resource /bin/bash
