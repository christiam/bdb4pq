#!/bin/bash
# gcp-utils/run-residue-count.sh: Counts the residues in a parquet file
#
# Author: Christiam Camacho (christiam.camacho@gmail.com)
# Created: Fri Mar  1 04:13:23 2019

SCRIPT_DIR=$(dirname $0)
source ${SCRIPT_DIR}/common.sh
set -euo pipefail

CLUSTER_ID=$($SCRIPT_DIR/get-my-active-cluster-id.sh)
SRC=$SCRIPT_DIR/../src/residue-count.py

if [ ! -z "$CLUSTER_ID" ] ; then
    gcloud dataproc jobs submit pyspark $SRC \
        --cluster ${CLUSTER_ID} \
        --region ${GCP_REGION} \
    -- -parquet gs://camacho-test/nr/nr.parquet $*
    #-- $*
fi

