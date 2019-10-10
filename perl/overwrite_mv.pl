#!/usr/bin/env perl

foreach $f (@ARGV) {
	if ($f =~ /\]\S/ or $f =~ /\.TXT$/) {
		$new = $f;
		$new =~ s/(\])(\S)/$1 $2/g;
		$new =~ s/\.TXT$/.txt/g;
		#rename $f, $2;
		if (-e $new) {
			$old = $new;
			$s1 = -s $f;
			$s2 = -s $old;
			if ($s1 > $s2) {
				print "$f($s1) --> $old($s2)\n";
				print "\t$f --> $new\n";
				rename $f, $new;
			} else {
				print "Delete $f\n";
				unlink $f;
			}
		} else {
			print "$f --> $new\n";
			rename $f, $new;
		}
	}
}
