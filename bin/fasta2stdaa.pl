#!/usr/bin/env perl
# Created: Fri 22 Sep 2017 11:10:43 AM EDT
use strict;
use warnings;
use File::Slurp;

my %table = (
    '-' =>  0,
    'A' =>  1,
    'B' =>  2,
    'C' =>  3,
    'D' =>  4,
    'E' =>  5,
    'F' =>  6,
    'G' =>  7,
    'H' =>  8,
    'I' =>  9,
    'K' => 10,
    'L' => 11,
    'M' => 12,
    'N' => 13,
    'P' => 14,
    'Q' => 15,
    'R' => 16,
    'S' => 17,
    'T' => 18,
    'V' => 19,
    'W' => 20,
    'X' => 21,
    'Y' => 22,
    'Z' => 23,
    'U' => 24,
    '*' => 25,
    'O' => 26,
    'J' => 27,
);

while (<>) {
    if (/^>/) {
        print;
        next;
    }
    chomp;
    my $line = join(',', map { $table{$_} } split(''));
    print "$line\n";
    #print "$_\n$line\n";
    #foreach my $residue (split("")) {
    #    if (not exists $table{$residue}) {
    #        print "Failed to find '$residue'\n";
    #    }
    #}
}

