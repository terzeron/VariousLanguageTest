#!/usr/bin/env perl

use strict;
use warnings;
use English;


my $num_days = 30;


sub check_qc
{
    my $keyword = shift;
    my $qc = shift;
    my $keyword_qc_map = shift;

    my $nosp = $keyword;
    $nosp =~ tr/ //d;
    $nosp =~ tr/A-Z/a-z/;

    if (exists $keyword_qc_map->{$keyword}) {
        return 0;
    } else {
        # not exist ... register
        $keyword_qc_map->{$keyword} = $qc;
    }
    return 0;
}


sub main
{
    my %keyword_qc_map = ();
    
    my $qc_file = "/home1/terzeron/cqc.txt";
    if (not open(F2, $qc_file)) {
        print STDERR "can't open '$qc_file', $ERRNO\n";
        return -1;
    }
    while (my $line = <F2>) {
        chomp $line;
        my ($repr, $qc_repr) = split /\t/, $line;
        #print "$repr - $qc_repr\n";
        my $ret;
        $ret = check_qc($repr, $qc_repr / $num_days, \%keyword_qc_map);
    }
    close(F2);
    
    my $qc_sum = 0;
    my $qc_threshold = 5;
    my $line_num = 0;
    
    my $data_file ="";
    if (not open(F1, $data_file)) {
        print STDERR "can't open '$data_file', $ERRNO\n";
        return -1;
    }
    while (my $line = <F1>) {
        chomp $line;
        ++$line_num;
        my ($repr, @assocs) = split /\t/, $line;
        my $nosp_repr = $repr;
        $nosp_repr =~ tr/ //d;
        $nosp_repr =~ tr/A-Z/a-z/;
        if (exists $keyword_qc_map{$nosp_repr}) {
            if ($keyword_qc_map{$nosp_repr} < $qc_threshold) {
                $qc_sum += $keyword_qc_map{$nosp_repr};
            }
        }
    }
    close(F1);

    print "The sum of QC: $qc_sum\n";
}


main();
