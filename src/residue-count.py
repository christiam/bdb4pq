#!/usr/bin/env python3
"""
residue-count.py - See DESC constant below

Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
Created: Fri 01 Mar 2019 04:05:42 PM EST
"""
import argparse
import time
from pyspark.sql import SparkSession
from operator import add

VERSION = '0.1'
DESC = r"""\
Pyspark script to find and count residues
"""
VALID_RESIDUES = [ '-', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 
    'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Y', 'Z', 'U', '*']
IN_DFLT = "gs://camacho-test/nr/nr.80.parquet"

def main():
    """ Entry point into this program. """
    parser = create_arg_parser()
    args = parser.parse_args()

    spark = SparkSession \
        .builder \
        .appName("residue-count") \
        .getOrCreate()

    df = spark.read.parquet(args.parquet)
    seqs = df.select("sequence").rdd.cache()

    for r in args.residue:
        start = time.time()
        num = seqs.map( lambda row : row.sequence.count(r) ).reduce(add)
        end = time.time()
        print("TIME RDD: Residue {} found {} times in {}".format(r, num, (end-start)))

    spark.stop()
    return 0

def create_arg_parser():
    """ Create the command line options parser object for this script. """
    parser = argparse.ArgumentParser(description=DESC)
    parser.add_argument("residue", nargs="+",
           choices=VALID_RESIDUES, help="Residue(s) to find and count")
    parser.add_argument("-parquet", default=IN_DFLT, help="Parquet file to search")
    return parser


if __name__ == "__main__":
    import sys
    sys.exit(main())

