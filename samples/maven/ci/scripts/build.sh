#!/bin/sh
set -e
set -x
ln -fs $(dirname $0)/java-cache/m2 ~/.m2
cd git-repo/samples/maven
./mvnw -o clean package
