#!/usr/bin/env python3
"""
rc.py - See DESC constant below

Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
Created: Fri 01 Mar 2019 04:05:42 PM EST
"""
import argparse
import unittest
import logging
from contextlib import closing

VERSION = '0.1'
DESC = r"""\
Pyspark script to find and count residues
"""
VALID_RESIDUES = [ '-', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 
    'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Y', 'Z', 'U', '*']


class Tester(unittest.TestCase):
    """ Testing class for this script. """
    def test_one(self):
        self.assertTrue(1)


def main():
    """ Entry point into this program. """
    parser = create_arg_parser()
    args = parser.parse_args()

    for r in args.residue:
        print(r)

    return 0

def create_arg_parser():
    """ Create the command line options parser object for this script. """
    parser = argparse.ArgumentParser(description=DESC)
    parser.add_argument("residue", nargs="+",
           choices=VALID_RESIDUES, help="Residue(s) to find and count")
    return parser


if __name__ == "__main__":
    import sys
    sys.exit(main())

