#!/bin/bash
# bin/get-nr-bdb.sh: What this script does
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Thu Oct  4 07:44:38 2018

SCRIPT_DIR=$(cd "`dirname "$0"`"; pwd)
source $SCRIPT_DIR/common.sh

BLASTDB=${1:-"$HOME/blastdb"}

cd $BLASTDB
#time update_blastdb.pl --decompress nr.80 &
#time update_blastdb.pl --decompress nr.81 &
#wait
time update_blastdb.pl --passive --decompress nr.81 --verbose
mv nr.pal nr.pal~
cat > nr.pal <<EOF
TITLE nr test subset
DBLIST nr.80 nr.81
EOF

