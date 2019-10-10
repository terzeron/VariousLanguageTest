#!/usr/bin/perl

$state = 0;

while (<>) {
	if (/대상 리스트/) {
		$state = 1;
		next;
	}
	if (/선 택/) {
		$state = 2;
		next;
	}
	if ($state == 1) {
		s/\s+/\n/g;
		s/\x1b\x5b\x6d\x0f/\n/g;
		s/\x1b\x5b[0-9]+\x43q?/\n/g;
		s/\x1b\x5bH/\n/g;
		s/\x1b\x5bJ/\n/g;
		s/\x1b\x5bK/\n/g;
		s/(\<\<)|(\>\>)/\n/g;
		s/\x1b\x5b\x30\x3b\x31\x3b\x37\x6d\x0f\-\-/\n/g;
		s/More/\n/g;
		s/\-\-/\n/g;
		s/ADMIN//g;
		print;
	}
}
