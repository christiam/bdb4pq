#!/bin/bash
# get-logs.sh: Fetches the logs for the spark cluster started with these scripts
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Fri 01 Mar 2019 12:36:54 PM EST

SCRIPT_DIR=$(dirname $0)
source ${SCRIPT_DIR}/common.sh
set -euo pipefail
shopt -s nullglob

gsutil -m rsync -r gs://$GCP_BUCKET_LOGS/ $SCRIPT_DIR/../
