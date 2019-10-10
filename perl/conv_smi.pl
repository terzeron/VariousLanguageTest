#!/usr/bin/env perl

$smi1 = 155100;
$avi1 = (03*60+03)*1000;
$smi2 = 5474100;
$avi2 = (1*3600+35*60+28)*1000;
$a = ($avi1 - $avi2) / ($smi1 - $smi2);
$b = $avi2 - $a * $smi2;

open(FILE, $ARGV[0]) or die "can't open file\n";

while (<FILE>) {
	if (/^\<SYNC Start=(\d+)\>(.*)$/) {
		$new = $1 * $a + $b;
		printf("<SYNC Start=%d>", $new);
		#print $new . ": " . int($new / 1000 / 60) . ":" . (($new / 1000) % 60) . "\n";
		print $2 . "\n";
	} else {
		print;
	}
}

