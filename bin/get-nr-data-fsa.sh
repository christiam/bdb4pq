#!/bin/bash
# get-nr-data-fsa.sh: extracts metadata from protein nr for testing purposes
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Thu Oct  4 07:02:21 2018

export PATH=/bin:/usr/bin:/Users/christiam/Downloads/ncbi-blast-2.8.0+/bin

time blastdbcmd -entry all -db nr -outfmt "%o|%g|%a|%T|%L|%X|%s|%l" -out nr.meta
