#!/bin/sh
set -e
ln -fs $(pwd)/java-cache/gradle ~/.gradle
cd git-repo/samples/gradle
./gradlew --project-cache-dir ~/.gradle/project --offline build
