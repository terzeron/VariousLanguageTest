#!/usr/bin/env perl

use strict;
use English;

my $service;
my $ts;
my $prev_service;
my $prev_ts;

while (<>) {
    $prev_service = "";
    $prev_ts = 0;
    while (m/\<N id=네이버\/([^\> \/]+)[^\>]* ts=(\d+)[^\>]*\>/g) {
	$service = $1;
	$ts = $2;
	if ($prev_service ne $service) {
	    if ($prev_ts > 0) {
		if ($ts > $prev_ts) {
		    print "$prev_service " . ($ts - $prev_ts) . "\n";
		}
	    }
	    $prev_service = $service;
	    $prev_ts = $ts;
	}
    }
    if ($prev_ts > 0) {
	if ($ts > $prev_ts) {
	    print "$prev_service " . ($ts - $prev_ts) . "\n";
	}
    }
}

