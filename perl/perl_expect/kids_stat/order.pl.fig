#!/usr/bin/perl

$sort_field = $ARGV[0];
$i = 1;
$j = 1;

while (<STDIN>) {
	if (/(\d+)\s+(\d+)\s+(\d+\.\d+)\s+(\S+)/) {
		$posting = $1;
		$login = $2;
		$ratio = $3;
		$userid = $4;
	}
	if ($sort_field == 1) {
		if ($posting == $prev) {
			$same = 1;
		} 
		$prev = $posting;
	} else {
		if ($login == $prev) {
			$same = 1;
		} 
		$prev = $login;
	}

	if ($same) {
		# 키 필드의 값이 같으면
		$j++;
	} else {
		# 키 필드의 값이 다르면
		$i = $j;
		$j++;
	}
	printf("%5d ", $i);	
	if ($login == 0) {
		printf("%8s %5d %5d %7.4f\n", $userid, $posting, $login, 0.0);
	} else {
		printf("%8s %5d %5d %7.4f\n", $userid, $posting, $login, $posting/$login);
	}
	$same = 0;
}
