#!/bin/sh
set -e
./samples/maven/mvnw -f ./samples/maven.pom.xml -o clean package
