#!/usr/bin/env perl

use strict;
use warnings;
use English;

my $keyword_file = "keyword.txt";
my $result_file1 = "nexearch_nobiz_090211.final";
my $result_file2 = "nexearch_090211.nobiz";


sub collect
{
    my $keyword_map = shift;
    my $result_file = shift;
    my $type = shift;

    open(F1, $result_file);
    while (my $line = <F1>) {
        chomp $line;
        my $repr = "";
        my $assocs = "";
        if ($type == 1) {
            if (not $line =~ /(.+):(.+)/) {
                next;
            }
            $repr = $1;
        } else {
            ($repr, $assocs) = split /\t/, $line;
        }
        $repr =~ tr/A-Z/a-z/;
        $repr =~ tr/ //d;
        $keyword_map->{$repr} = $line;
    }
    close(F1);
}


sub main
{
    my %keyword_map1 = ();
    my %keyword_map2 = ();
    collect(\%keyword_map1, $result_file1, 1);
    collect(\%keyword_map2, $result_file2, 2);
    my $size1 = scalar keys %keyword_map1;
    my $size2 = scalar keys %keyword_map2;

    open(F2, $keyword_file);
    while (my $repr = <F2>) {
        chomp $repr;
        my $nosp_repr = $repr;
        $nosp_repr =~ tr/A-Z/a-z/;
        $nosp_repr =~ tr/ //d;
        if (exists $keyword_map1{$nosp_repr}) {
            my $line = $keyword_map1{$nosp_repr};
            if (not $line =~ /(.+):(.+)/) {
                next;
            }
            my $repr = $1;
            my $assocs = $2;

            my $cnt = 0;
            my @assoc_list = split /\^/, $assocs;
            print "$repr\t" . scalar @assoc_list;

            foreach my $assoc (@assoc_list) {
                if ($cnt++ < 30) {
                    print "\t$assoc";
                }
            }
            print "\n";
        } else {
            print "$repr\t0\t---\t연관어\t없음\t---\n";
        }
        if (exists $keyword_map2{$nosp_repr}) {
            my $line = $keyword_map2{$nosp_repr};
            my ($repr, $assocs) = split /\t/, $line, 2;

            my $cnt = 0;
            my @assoc_list = split /\t/, $assocs;
            print "$repr\t" . scalar @assoc_list;

            foreach my $assoc (@assoc_list) {
                if ($cnt++ < 30) {
                    print "\t$assoc";
                }
            }
            print "\n";
        } else {
            print "$repr\t0\t---\t연관어\t없음\t---\n";
        }
    }
    close(F2);
}

main();
