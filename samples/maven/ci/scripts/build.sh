#!/bin/sh
set -e
ln -fs $(pwd)/java-cache/m2 ~/.m2
cd git-repo/samples/maven
./mvnw -o clean package
