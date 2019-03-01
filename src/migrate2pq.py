#! /usr/bin/env python3

from pyspark.sql import SparkSession


if __name__ == "__main__":
    spark = SparkSession \
        .builder \
        .appName("migrate2pq") \
        .getOrCreate()


    file_name = "gs://dataproc-logs-christiam/nr-small-meta.csv"
    print("Reading {}".format(file_name))
    df = spark.read.load(file_name, format="csv", sep="|", inferSchema="true", header="true")

    print("Writing WITH select")
    df.select("accession", "gi", "taxid", "sci_name", "sequence", "slen")\
        .write.mode("overwrite").save("gs://dataproc-logs-christiam/bdb.parquet", format="parquet")

    print("Writing without select")
    df.write.mode("overwrite").parquet("gs://dataproc-logs-christiam/nr-small.parquet")

    pqFile = spark.read.parquet("gs://dataproc-logs-christiam/nr-small.parquet")
    pqFile.createOrReplaceTempView("pqFile")
    human = spark.sql("SELECT * FROM pqFile where taxid == 9606")
    human.show()


    spark.stop()