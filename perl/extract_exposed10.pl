#!/usr/bin/env perl

use strict;
use warnings;
use English;

my $rank_num = 0;
while (my $line = <>) {
    chomp $line;
    my @list = split /\t/, $line;
    if ($list[1] == "0") {
        ++$rank_num;
    } else {
        next;
    }

    print $list[0] . "\n";
    
    if ($rank_num >= 10) {
        last;
    }
}
