#!/usr/bin/env perl
# Post-process BLASTDB metadata output for ingestion in parquet
use strict;
use warnings;
use autodie;
use lib::abs;

#open(my $in, "<", "data/nr100.csv");
#open(my $out, ">", "data/nr4pq.csv");
#print $out "#seqid,taxid,seq,seqlen\n";

open(my $in, "gunzip -c data/nr.meta.gz|");
open(my $out, ">", "data/nr4pq-large.csv");
while (<$in>) {
    chomp;
    my @F = split(/\|/);
    print $out "$F[2]|$F[3]|$F[6]|$F[7]\n";
}
