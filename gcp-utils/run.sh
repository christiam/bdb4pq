#!/bin/bash
# gcp-utils/run.sh: What this script does
#
# Author: Christiam Camacho (christiam.camacho@gmail.com)
# Created: Fri Mar  1 04:13:23 2019

SCRIPT_DIR=$(dirname $0)
[ -z "$GCP_PROJECT" ] && source ${SCRIPT_DIR}/common.sh
set -euo pipefail
shopt -s nullglob

CLUSTER_ID=$($SCRIPT_DIR/get-active-cluster-id.sh)
SRC=$SCRIPT_DIR/../src/migrate2pq.py

if [ ! -z "$CLUSTER_ID" ] ; then
    gcloud dataproc jobs submit pyspark $SRC \
        --cluster ${CLUSTER_ID} \
        --region ${GCP_REGION}
fi

