#! /usr/bin/env python3
"""
migrate2pq.py - See DESC constant below

Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
Created: Fri 01 Mar 2019 04:05:42 PM EST
"""

from pyspark.sql import SparkSession
import argparse
import time

VERSION = '0.1'
DESC = r"""\
Pyspark script to migrate CSV files to Parquet
"""
IN_DFLT = "gs://camacho-test/nr/nr.01-meta.csv"
OUT_DFLT = "gs://camacho-test/nr/nr.01-meta.parquet"

def main():
    parser = create_arg_parser()
    args = parser.parse_args()

##    spark = SparkSession \
##        .builder \
##        .appName("migrate2pq") \
##        .getOrCreate()


    print("Reading {}".format(args.input_file))
    start = time.time()
    ##df = spark.read.load(args.input, format="csv", sep="|", inferSchema="true", header="true")
    end = time.time()
    print("Reading done in {}".format(end - start))

    print("Writing {}".format(args.out))
    start = time.time()
    ##df.write.mode("overwrite").parquet(args.out)
    end = time.time()
    print("Writing done in {}".format(end - start))
    # df.createOrReplaceTempView("pqFile")
    # human = spark.sql("SELECT * FROM pqFile where taxid == 9606")
    # human.show()
    ##spark.stop()


def create_arg_parser():
    """ Create the command line options parser object for this script. """
    parser = argparse.ArgumentParser(description=DESC)
    parser.add_argument("input_file", nargs="?", default=IN_DFLT, help="Source file name")
    parser.add_argument("out", nargs="?", default=OUT_DFLT, help="Output file name")
    return parser


if __name__ == "__main__":
    import sys
    sys.exit(main())

