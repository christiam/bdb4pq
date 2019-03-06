#!/bin/bash
# bin/run-java-residue-count.sh: Counts the residues in a parquet file
#
# Author: Christiam Camacho (christiam.camacho@gmail.com)
# Created: Tue 05 Mar 2019 10:50:01 PM EST

SCRIPT_DIR=$(dirname $0)
set -euo pipefail

MASTER=yarn
MAIN_CLASS=gov.nih.nlm.ncbi.app.ResidueCount
JAR=$(find target -type f -name "*.jar")
INPUT=hdfs:///user/camacho/nr.80.parquet
SPARK_HOME=/usr/local/spark/2.3.2
#JARS=$SPARK_HOME/jars/snappy-0.2.jar,$SPARK_HOME/jars/snappy-java-1.1.2.6.jar
#JARS=$SPARK_HOME/jars/snappy-java-1.1.2.6.jar
#SNAPPY_OPTS='-Dorg.xerial.snappy.lib.name=libsnappyjava.jnilib -Dorg.xerial.snappy.tempdir=/tmp '

set -x
export SPARK_PRINT_LAUNCH_COMMAND=1
time spark-submit --master ${MASTER} \
    --queue prod.blast \
    --name "java-residue-count" \
    --verbose \
    --class $MAIN_CLASS $JAR \
    -parquet $INPUT $*

