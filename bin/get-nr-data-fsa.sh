#!/bin/bash
# get-nr-data-fsa.sh: extracts metadata from protein nr for testing purposes
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Thu Oct  4 07:02:21 2018

SCRIPT_DIR=$(cd "`dirname "$0"`"; pwd)
source $SCRIPT_DIR/common.sh
OUTPUT_DATA=$(realpath $SCRIPT_DIR/../data)
BLASTDB=/panfs/pan1.be-md.ncbi.nlm.nih.gov/blastprojects/GCP_blastdb/orig_dbs
DB=$BLASTDB/nr
[ -d $OUTPUT_DATA ] || mkdir -p $OUTPUT_DATA

for vol in $(grep DBLIST $DB.pal | sed 's/DBLIST //' | tr -d '"' ); do
    OUT=$OUTPUT_DATA/$vol-meta-header.csv
    echo "accession|gi|taxid|sci_name|sequence|slen" > $OUT
done
set -x
parallel --use-cores-instead-of-threads --jobs 50% -q -t --header : --results $OUTPUT_DATA \
    blastdbcmd -entry all -db $BLASTDB/{} \
    -outfmt '%a|%g|%T|%S|%s|%l' -out $OUTPUT_DATA/{}-meta.csv ::: vols $(grep DBLIST $DB.pal | sed 's/DBLIST //' | tr -d '"' )

# Add the header
TMP=`mktemp -p $PWD -t $(basename -s .sh $0)-XXXXXXX`
trap " /bin/rm -fr $TMP " INT QUIT EXIT HUP KILL ALRM

for vol in $(grep DBLIST $DB.pal | sed 's/DBLIST //' | tr -d '"' ); do
    HEADER=$OUTPUT_DATA/$vol-meta-header.csv
    DATA=$OUTPUT_DATA/$vol-meta.csv
    cat $HEADER $DATA > $TMP
    cp $TMP $DATA
    rm $HEADER
done
