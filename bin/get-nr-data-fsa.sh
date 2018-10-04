#!/bin/bash
# get-nr-data-fsa.sh: extracts metadata from protein nr for testing purposes
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Thu Oct  4 07:02:21 2018

SCRIPT_DIR=$(cd "`dirname "$0"`"; pwd)
source $SCRIPT_DIR/common.sh

time blastdbcmd -entry all -db nr -outfmt "%o|%g|%a|%T|%L|%X|%s|%l" \
    -out $SCRIPT_DIR/../data/nr.meta
