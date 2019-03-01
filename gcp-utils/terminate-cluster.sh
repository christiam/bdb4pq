#! /bin/bash
SCRIPT_DIR=$(dirname $0)
source ${SCRIPT_DIR}/common.sh
set -euo pipefail

if [ $# == 1 ] ; then
    CLUSTER_ID=$1
else
    SCRIPT_DIR=$(dirname $0)
    CLUSTER_ID=$($SCRIPT_DIR/get-my-active-cluster-id.sh)
fi

if [ ! -z "$CLUSTER_ID" ] ; then
    gcloud dataproc clusters delete $CLUSTER_ID --region ${GCP_REGION}
fi
