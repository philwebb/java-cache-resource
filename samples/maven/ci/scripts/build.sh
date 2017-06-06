#!/bin/sh
set -e
ln -s java-cache/m2 ~/.m2
cd git-repo/samples/maven
./mvnw -o clean package
