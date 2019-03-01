#!/bin/bash
# ../gcp-utils/mb.sh: What this script does
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Fri 01 Mar 2019 10:05:16 AM EST

SCRIPT_DIR=$(dirname $0)
source ${SCRIPT_DIR}/common.sh

set -euo pipefail
shopt -s nullglob

gsutil mb -l $GCP_REGION -c regional gs://${GCP_BUCKET}
gsutil iam ch allUsers:objectViewer ${GCP_BUCKET}
