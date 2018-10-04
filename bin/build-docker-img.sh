#!/bin/bash
# build-docker-img.sh: What this script does
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Thu 04 Oct 2018 09:36:43 AM WEST

export PATH=/bin:/usr/bin
set -euo pipefail
shopt -s nullglob

SCRIPT_DIR=$(cd "`dirname "$0"`"; pwd)
source $SCRIPT_DIR/common.sh

docker build --build-arg version=${BLAST_VERSION} \
    -t $DOCKER_USER/$DOCKER_IMG:$BLAST_VERSION -f $SCRIPT_DIR/../etc/Dockerfile .
#docker build -t $DOCKER_USER/$DOCKER_IMG:$BLAST_VERSION -f $SCRIPT_DIR/../etc/Dockerfile .
docker tag $DOCKER_USER/$DOCKER_IMG:$BLAST_VERSION $DOCKER_USER/$DOCKER_IMG:latest
