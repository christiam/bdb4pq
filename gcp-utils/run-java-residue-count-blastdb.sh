#!/bin/bash
# gcp-utils/run-residue-count.sh: Counts bytes equal to 0x01 in a binary file
#
# Author: Greg Boratyn
# Created: Fri Mar  29, 2019

SCRIPT_DIR=$(dirname $0)
source ${SCRIPT_DIR}/common.sh
set -euo pipefail

MAIN_CLASS=gov.nih.nlm.ncbi.app.ResidueCountBlastDB
JAR=$(find target -type f -name "*-with-dependencies.jar")
CLUSTER_ID=$($SCRIPT_DIR/get-my-active-cluster-id.sh)

if [ ! -z "$CLUSTER_ID" ] ; then
    set -x
    gcloud dataproc jobs submit spark --jars $JAR \
        --class ${MAIN_CLASS} \
        --cluster ${CLUSTER_ID} \
        --region ${GCP_REGION}
fi

