#!/bin/bash

SCRIPT_DIR=$(dirname $0)
source ${SCRIPT_DIR}/common.sh

if [ ! -z "$CLUSTER_ID" ] ; then
    echo $CLUSTER_ID
else
    gcloud dataproc clusters list \
        --region ${GCP_REGION} \
        --filter="status.state = ACTIVE AND clusterName = $USER-test-cluster" \
        --format json | jq -r .[].clusterName 
fi
