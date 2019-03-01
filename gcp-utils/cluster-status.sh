#! /bin/bash
SCRIPT_DIR=$(dirname $0)
source ${SCRIPT_DIR}/common.sh
set -euo pipefail

if [ $# == 1 ] ; then
    CLUSTER_ID=$1
else
    CLUSTER_ID=$($SCRIPT_DIR/get-my-active-cluster-id.sh)
fi

if [ ! -z "$CLUSTER_ID" ] ; then
    echo "##################################### STEPS #################################";
    gcloud dataproc jobs list --cluster $CLUSTER_ID --region ${GCP_REGION}
    echo "##################################### CLUSTER INFO #################################";
    gcloud dataproc clusters describe $CLUSTER_ID --region ${GCP_REGION}
else
    gcloud dataproc jobs list --region ${GCP_REGION}
fi
