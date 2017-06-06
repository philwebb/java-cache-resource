#!/bin/sh
set -e
set -x
ln -fs $(pwd)/java-cache/gradle ~/.gradle
cd git-repo/samples/gradle
./gradlew --offline build
