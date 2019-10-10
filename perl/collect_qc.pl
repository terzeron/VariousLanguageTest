#!/usr/bin/env perl

use strict;
use warnings;
use English;

my @day_list = (
"090113", "090114", "090115", "090116", "090117", "090118", "090119", "090120", "090121", "090122", "090123", "090124", "090125", "090126", "090127", "090128", "090129", "090130", "090131", "090201", "090202", "090203", "090204", "090205", "090206", "090207", "090208", "090209", "090210", "090211");

chdir("nexearch");

my %keyword_qc_map = ();
foreach my $day (@day_list) {
    if (not open(IN, "cqc_$day")) {
        print STDERR "can't open cqc_$day\n";
        exit(-1);
    }
    while (my $line = <IN>) {
        chomp $line;
        my ($repr, $qc) = split /\t/, $line;
        if (exists $keyword_qc_map{$repr}) {
            $keyword_qc_map{$repr} += $qc;
        } else {
            $keyword_qc_map{$repr} = $qc;
        }
    }
    close(IN);
}


foreach my $repr (keys %keyword_qc_map) {
    print $repr . "\t" . $keyword_qc_map{$repr} . "\n";
}
