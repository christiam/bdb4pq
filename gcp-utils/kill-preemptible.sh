#!/bin/bash
# gcp-utils/kill-preemptible.sh: terminates a preemtible note on the cluster
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Thu 14 Mar 2019 11:39:14 AM EDT

set -euo pipefail
shopt -s nullglob

victim=`gcloud compute instances list | grep $USER-test-cluster | egrep -v '\-m|\-w' | \
    awk '{print $1}'`
if [ ! -z "$victim" ] ; then
    gcloud compute instances delete $victim
fi
gcloud compute instances list
