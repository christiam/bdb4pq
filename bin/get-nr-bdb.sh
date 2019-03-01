#!/bin/bash
# bin/get-nr-bdb.sh: What this script does
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Thu Oct  4 07:44:38 2018

SCRIPT_DIR=$(cd "`dirname "$0"`"; pwd)
source $SCRIPT_DIR/common.sh

BLASTDB=${1:-"$SCRIPT_DIR/../blastdb"}

[ -d $BLASTDB ] || mkdir -p $BLASTDB
cd $BLASTDB
[ -f nr.80.pin ] || time update_blastdb.pl --decompress nr.80 &
[ -f nr.81.pin ] || time update_blastdb.pl --decompress nr.81 &
wait
mv nr.pal nr.pal~
cat > nr.pal <<EOF
TITLE nr test subset
DBLIST nr.80 nr.81
EOF

