#!/usr/local/bin/perl
# 
# cut.pl
#
# This script cut commas and white space of temporary file.
# Made by terzeron@indra.snu.ac.kr, 97/03/13

$/ = "";
$* = 1;

while (<>) {
    s/ /\n/g;
    print;
}
