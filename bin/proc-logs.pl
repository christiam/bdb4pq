#!/usr/bin/env perl
# Process logs to generate runtime data for gnuplot
# Created: Thu 14 Mar 2019 09:53:10 AM EDT
use strict;
use warnings;

$\ = "\n", $, = " ";
my %data;
my @residues;
while (<>) {
    chomp;
    if (/^TIME: Residue (.) found (\d+) times in (\d+\.\d+) s/) {
        $data{'java_df'}{$1}{'time'} = $3;
        $data{'java_df'}{$1}{'count'} = $2;
        push @residues, $1;
    }
    if (/^TIME RDD: Residue (.) found (\d+) times in (\d+\.\d+) s/) {
        $data{'java_rdd'}{$1}{'time'} = $3;
        $data{'java_rdd'}{$1}{'count'} = $2;
    }
    if (/^TIME RDD: Residue (.) found (\d+) times in (\d+\.\d+)/) {
        $data{'python_rdd'}{$1}{'time'} = $3;
        $data{'python_rdd'}{$1}{'count'} = $2;
    }
}

# Sanity check: check counts are the same
foreach my $res (@residues) {
    my ($i, $cnt) = (0,0);
    foreach (sort keys %data) {
        if ($i++ == 0) { 
            $cnt = $data{$_}{$res}{'count'};
            next;
        }
        if ($cnt != $data{$_}{$res}{'count'}) {
            print STDERR "Error in residue counts for $res: $cnt vs $data{$_}{$res}{'count'}";
            exit(1);
        }
    }
}

# print data file
foreach my $res (@residues) {
    my @times;
    foreach (sort keys %data) {
        push @times, $data{$_}{$res}{'time'};
    }
    print @times;
}
