#!/bin/bash
# dataproc-create-blast-cluster.sh: Creates a dataproc cluster
#
# Author: Christiam Camacho (christiam.camacho@gmail.com)
# Created: Mon Feb  4 12:09:54 2019

SCRIPT_DIR=$(dirname $0)
[ -z "$GCP_PROJECT" ] && source ${SCRIPT_DIR}/common.sh
set -euo pipefail

NAME=${USER}-test-cluster
NUM_WORKERS=0

while getopts "i:n:" OPT; do
    case $OPT in 
        n) NUM_WORKERS=${OPTARG}
            ;;
        i) NAME=${OPTARG}
            ;;
    esac
done

# NT takes about 49GB, NR 116GB
MASTER=n1-standard-4
DISK_PER_MASTER=400 # For test data

DATAPROC_BUCKET=dataproc-logs-$USER
INIT_BUCKET=gs://spark-experiments

if [ $NUM_WORKERS == 0 ] ; then
    set -x
    gcloud dataproc clusters create $NAME --single-node \
        --project ${GCP_PROJECT} \
        --region ${GCP_REGION} \
        --zone   ${GCP_ZONE} \
        --master-machine-type $MASTER \
        --master-boot-disk-size $DISK_PER_MASTER \
        --scopes cloud-platform \
        --labels project=blast,creator=$USER,project=blast-mr,owner=$USER,maintainer=camacho \
        --image-version 1.3 \
        --properties dataproc:dataproc.monitoring.stackdriver.enable=true,dataproc:dataproc.logging.stackdriver.enable=true, \
        --initialization-action-timeout 30m \
        --initialization-actions $INIT_BUCKET/dataproc-ganglia.sh \
        --bucket $DATAPROC_BUCKET
else
    MASTER=n1-standard-2
    WORKER=n1-standard-2
    #WORKER=n1-standard-16
    DISK_PER_WORKER=200
    PREEMPT_WORKERS=1
    set -x
    gcloud dataproc clusters create $NAME \
        --project ${GCP_PROJECT} \
        --region ${GCP_REGION} \
        --zone   ${GCP_ZONE} \
        --master-machine-type $MASTER \
        --worker-machine-type $WORKER \
        --num-workers $NUM_WORKERS \
        --master-boot-disk-size $DISK_PER_MASTER \
        --worker-boot-disk-size $DISK_PER_WORKER \
        --num-preemptible-workers $PREEMPT_WORKERS \
        --preemptible-worker-boot-disk-size $DISK_PER_WORKER \
        --scopes cloud-platform \
        --labels project=blast,creator=$USER,project=blast-mr,owner=$USER,maintainer=camacho \
        --image-version 1.3 \
        --properties dataproc:dataproc.monitoring.stackdriver.enable=true,dataproc:dataproc.logging.stackdriver.enable=true, \
        --initialization-action-timeout 30m \
        --initialization-actions $INIT_BUCKET/dataproc-ganglia.sh \
        --bucket $DATAPROC_BUCKET
fi
