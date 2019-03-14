/* 
 * ===========================================================================
 *
 *                            PUBLIC DOMAIN NOTICE
 *               National Center for Biotechnology Information
 *
 *  This software/database is a "United States Government Work" under the
 *  terms of the United States Copyright Act.  It was written as part of
 *  the author's official duties as a United States Government employee and
 *  thus cannot be copyrighted.  This software/database is freely available
 *  to the public for use. The National Library of Medicine and the U.S.
 *  Government have not placed any restriction on its use or reproduction.
 *
 *  Although all reasonable efforts have been taken to ensure the accuracy
 *  and reliability of the software and data, the NLM and the U.S.
 *  Government do not and cannot warrant the performance or results that
 *  may be obtained by using this software or data. The NLM and the U.S.
 *  Government disclaim all warranties, express or implied, including
 *  warranties of performance, merchantability or fitness for any particular
 *  purpose.
 *
 *  Please cite the author in any work or product based on this material.
 *
 * ===========================================================================
 */

package gov.nih.nlm.ncbi.app;

import org.apache.commons.lang.StringUtils;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.sql.*;
import org.apache.spark.api.java.function.*;

//import org.apache.spark.api.java.JavaSparkContext;

import com.google.common.base.Stopwatch;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.GnuParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;

/** Program to count residues in a parquet file
 *
 * @author Christiam Camacho
 */
public class ResidueCount {
  /* Command line arguments */
  private static final String ARG_INPUT = "parquet";
  /* Data members */
  private static String _input = null;

  //private static final Log LOG = LogFactory.getLog(ResidueCount.class);
  public static void main(String[] args) throws ParseException {
    if (!processCLI(args)) {
      System.exit(1);
    }
    SparkSession spark = SparkSession.builder().getOrCreate();
    Dataset<Row> df = spark.read().parquet(_input);
    df.createOrReplaceTempView("parquet_data");
    //df.show();

    Dataset<Row> seqs = spark.sql("SELECT sequence FROM parquet_data").cache();
    Encoder<Long> longEncoder = Encoders.LONG();
    for (String residue : args) {
        if (residue.length() != 1)
          continue;
        Stopwatch timer = new Stopwatch().start();
        long num = seqs.map
          ((MapFunction<Row, Long>) row -> (long)StringUtils.countMatches(row.getString(0), residue), longEncoder)
          .reduce( (ReduceFunction<Long>) (a, b) -> a + b);
        timer.stop();
        System.out.println(String.format("TIME: Residue %s found %d times in %s", residue, num, timer));
    }
    seqs.unpersist();

    JavaRDD<Row> seqs_rdd = spark.sql("SELECT sequence FROM parquet_data").toJavaRDD().setName("sequences").cache();
    for (String residue : args) {
      if (residue.length() != 1)
        continue;
      Stopwatch timer = new Stopwatch().start();
      long num = seqs_rdd.map(
              (Function<Row, Long>) row -> (long)StringUtils.countMatches(row.getString(0), residue))
              .reduce( (Function2<Long, Long, Long>) (a,b) -> a+ b);
      timer.stop();
      System.out.println(String.format("TIME RDD: Residue %s found %d times in %s", residue, num, timer));
    }
    spark.stop();
  }

  private static boolean processCLI(String[] args) throws ParseException {
    Options options = new Options();
    options.addOption(new Option("help", "print this message"));
    options.addOption(OptionBuilder.withLongOpt(ARG_INPUT).hasArg()
        .withDescription("Parquet file to scan").isRequired().create());

    CommandLineParser parser = new GnuParser();
    CommandLine cli = parser.parse(options, args);

    if (cli.hasOption("help")) {
      HelpFormatter formatter = new HelpFormatter();
      formatter.printHelp(ResidueCount.class.getSimpleName(), options);
      return false;
    }
    if (cli.hasOption(ARG_INPUT)) {
      _input = cli.getOptionValue(ARG_INPUT);
    }
    return true;
  }
}

