#!/bin/bash
# gcp-utils/run-residue-count.sh: Counts the residues in a parquet file
#
# Author: Christiam Camacho (christiam.camacho@gmail.com)
# Created: Fri Mar  1 04:13:23 2019

SCRIPT_DIR=$(dirname $0)
set -euo pipefail

SRC=$SCRIPT_DIR/../src/residue-count.py
INPUT=hdfs:///user/$USER/nr.80.parquet

export SPARK_PRINT_LAUNCH_COMMAND=1
time spark-submit --master local[2] \
    --name "residue-count" \
    --verbose \
    $SRC -parquet gs://camacho-test/nr/nr.parquet $*

