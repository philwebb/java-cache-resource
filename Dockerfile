FROM openjdk:8-jdk-alpine

RUN apk add --no-cache curl tar bash git jq sed

ADD scripts/install-git-lfs.sh install-git-lfs.sh
RUN ./install-git-lfs.sh

ADD scripts/install-git-resource.sh install-git-resource.sh
RUN ./install-git-resource.sh

ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/check /opt/resource/in /opt/resource/out
