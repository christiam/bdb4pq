#!/bin/bash
# bin/run-residue-count.sh: Counts the residues in a parquet file
#
# Author: Christiam Camacho (christiam.camacho@gmail.com)
# Created: Fri Mar  1 04:13:23 2019

SCRIPT_DIR=$(dirname $0)
set -euo pipefail

MASTER=yarn
SRC=$(realpath $SCRIPT_DIR/../src/residue-count.py)
INPUT=hdfs:///user/camacho/nr.80.parquet
SPARK_HOME=/usr/local/spark/2.3.2
#JARS=$SPARK_HOME/jars/snappy-0.2.jar,$SPARK_HOME/jars/snappy-java-1.1.2.6.jar
JARS=$SPARK_HOME/jars/snappy-java-1.1.2.6.jar
SNAPPY_OPTS='-Dorg.xerial.snappy.lib.name=libsnappyjava.jnilib -Dorg.xerial.snappy.tempdir=/tmp '

set -x
export SPARK_PRINT_LAUNCH_COMMAND=1
time spark-submit --master ${MASTER} \
    --queue prod.blast \
    --name "residue-count" \
    --verbose \
    --jars ${JARS} \
    --conf spark.executor.extraJavaOptions="${SNAPPY_OPTS}" \
    --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
    $SRC -parquet $INPUT $*

