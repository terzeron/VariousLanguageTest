#!/usr/bin/perl

$i = 1;
$j = 1;

while (<STDIN>) {
    # userid diff_of_posting diff_of_login
    if (/\s*(\S+)\s*(\d+)\s*(\d+)\s*(\d+\.\d+)/) {
        $userid = $1;
        $diff_posting = $2;
        $diff_login = $3;
        $ratio = $4;
    }
    # 기준 필드
    if ($ARGV[0] == 1) {
        if ($diff_posting == $prev) {
            $same = 1;
        }
        $prev = $diff_posting;
    } elsif ($ARGV[0] == 2) {
        if ($diff_login == $prev) {
            $same = 1;
        }
        $prev = $diff_login;
    }

    if ($same) {
        # 키 필드의 값이 같으면
        $j++;
    } else {
        # 키 필드의 값이 다르면
        $i = $j;
        $j++;
    }
    printf("%4d ", $i);	
    printf("%8s %4d %4d %7.4f\t\n", $userid, $diff_posting, $diff_login, $ratio);
    $same = 0;
}
