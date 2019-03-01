#!/bin/bash
# get-nr-data-fsa.sh: extracts metadata from protein nr for testing purposes
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Thu Oct  4 07:02:21 2018

SCRIPT_DIR=$(cd "`dirname "$0"`"; pwd)
source $SCRIPT_DIR/common.sh
<<<<<<< Updated upstream
OUTPUT_DATA=$(realpath $SCRIPT_DIR/../data)
DB=/panfs/pan1.be-md.ncbi.nlm.nih.gov/blastprojects/GCP_blastdb/orig_dbs/nr
[ -d $OUTPUT_DATA ] || mkdir -p $OUTPUT_DATA
OUT=$OUTPUT_DATA/nr-meta.csv
echo "accession|gi|taxid|sci_name|sequence|slen" > $OUT
time blastdbcmd -entry all -db $DB \
    -outfmt "%a|%g|%T|%S|%s|%l" >> $OUT
#time docker run --rm -v $BLASTDB:/blast/blastdb:ro ncbi/blast blastdbcmd -entry all -db nr \
#    -outfmt "%a|%g|%T|%S|%s|%l" >> $OUT
#gsutil cp -m $OUT gs://dataproc-logs-$USER/
