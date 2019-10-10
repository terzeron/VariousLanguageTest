#!/usr/bin/env perl

use strict;
use English;

open(F1, $ARGV[0]) or 
    die "can't open '" . $ARGV[0] . "', for reading, " . $ERRNO . "\n";
open(F2, $ARGV[1]) or 
    die "can't open '" . $ARGV[1] . "', for reading, " . $ERRNO . "\n";

my $repr;
my $qc;
my $assocs;
my $assoc;
my @assoc_and_lift_list;
my %repr_assoc_existence_map = ();
my $num_first_keyword = 0;
my $num_second_keyword = 0;
my $num_obsolete_keyword = 0;
my $num_new_keyword = 0;
my $num_second_repr_keyword = 0;
my $qc_threshold = $ARGV[2];

while (<F1>) {
    chomp;
    ($repr, $qc, @assoc_and_lift_list) = split /\t/;
    if ($qc < $qc_threshold) {
	next;
    }
    $repr =~ tr/A-Z/a-z/;
    $repr =~ tr/ //d;
    $repr_assoc_existence_map{$repr} = 1;
    ++$num_first_keyword;
    while (scalar @assoc_and_lift_list > 0) {
	my $assoc = shift @assoc_and_lift_list;
	my $lift = shift @assoc_and_lift_list;
	$assoc =~ tr/A-Z/a-z/;
	$assoc =~ tr/ //d;
	$repr_assoc_existence_map{$assoc} = 1;
	++$num_first_keyword;
    }
}
close(F1);

while (<F2>) {
    chomp;
    ($repr, $qc, @assoc_and_lift_list) = split /\t/;
    if ($qc < $qc_threshold) {
	next;
    }
    $repr =~ tr/A-Z/a-z/;
    $repr =~ tr/ //d;
    if (exists $repr_assoc_existence_map{$repr} and
	$repr_assoc_existence_map{$repr} == 1) {
	# already exists
	++$num_obsolete_keyword;
    } else {
	# new keyword
	++$num_new_keyword;
    }
    ++$num_second_keyword;
    ++$num_second_repr_keyword;
    while (scalar @assoc_and_lift_list > 0) {
	my $assoc = shift @assoc_and_lift_list;
	my $lift = shift @assoc_and_lift_list;
	$assoc =~ tr/A-Z/a-z/;
	$assoc =~ tr/ //d;
	if (exists $repr_assoc_existence_map{$assoc} and
	    $repr_assoc_existence_map{$assoc} == 1) {
	    # aleady exists
	    ++$num_obsolete_keyword;
	} else {
	    # new keyword
	    #print "$repr\t$assoc\n";
	    ++$num_new_keyword;
	}
	++$num_second_keyword;
    }
}
close(F2);

#print "first: " . $num_first_keyword . "\n";
#print "second: " . $num_second_keyword . "\n";
#print "new in second: " . $num_new_keyword . "\n";
#print "obsolete in second: " . $num_obsolete_keyword . "\n";
#print "second repr: " . $num_second_repr_keyword . "\n";

print $num_new_keyword . "\t\t" . $num_second_repr_keyword . "\n";
