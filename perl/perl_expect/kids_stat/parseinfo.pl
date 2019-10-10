#!/usr/bin/perl

while ($line = <ARGV>) {
	if ($line =~ / UserID  : (.*)\r\r/) {
		$userid = $1;
	    next;
    }
    if ($line =~ / Login\s+:\s+(\d+) 번.*올린글 :\s+(\d+) 개/) {
        $numlogin = $1;
        $numposting = $2;
	}
	if ($line =~ /\[리턴\] 키를 치십시오/) {
		if ($userid ne "" and not $userid =~ /\007/ and $numlogin ne "" and $numposting ne "") {
			if ($numlogin == 0) {
				printf("%5d %5d %10.4f %10s\n", $numposting, $numlogin, 0.0, $userid);
			} else {
				printf("%5d %5d %10.4f %10s\n", $numposting, $numlogin, $numposting/$numlogin, $userid);
			}
		}
		$userid = "";
		$numlogin = "";
		$numposting = "";
		next;
	}
}

