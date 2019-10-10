#!/usr/bin/perl

# except_userlist에 존재하는 사용자 명단을 userlist에서 제거함

open(USERLIST, "userlist") or die "can't open userlist";
open(EXCEPT, "except_userlist") or die "can't open except_userlist";

while ($user2 = <EXCEPT>) {
	chomp $user2;
	$hash{$user2} = $user2;
}

while ($user1 = <USERLIST>) {
	chomp $user1;
	if ($user1 eq $hash{$user1}) {
		next;
	}
	print "$user1\n";
}

close(EXCEPT);
close(USERLIST);

