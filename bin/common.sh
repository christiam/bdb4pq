#!/bin/bash
# bin/common.sh: Common settings for scripts in this repo
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Thu Oct  4 07:51:26 2018

export BLASTDB=$(realpath $(dirname "$0")/../blastdb)
