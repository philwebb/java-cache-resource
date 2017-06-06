#!/bin/sh
set -e
(cd ./samples/maven && ./mvnw -o clean package)
 
