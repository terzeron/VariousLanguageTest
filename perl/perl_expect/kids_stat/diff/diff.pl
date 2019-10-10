#!/usr/bin/perl

open(STAT_OLD, "result.old")
    or die "can't open result file for reading";
open(STAT_NEW, "result.new")
    or die "can't open result file for reading";
open(STAT_EXT, "> exception_list")
    or die "can't open result file for writing";

while (<STAT_OLD>) {
    chomp;
    ($numposting, $numlogin, $temp, $userid) = /(\d+)\s+(\d+)\s+(\d+\.\d+)\s+(\S+)$/;
    $hash_old{$userid} = [$numposting, $numlogin];

    # 아이디 중복 처리
    if ($userid =~ /\x07/) {
        delete($hash_old{$userid});
        next;
    } 
    if ($prev_numposting == $numposting and $prev_numlogin == $numlogin) {
        #print "## $prev_userid $userid\n";
        if (length($prev_userid) > length($userid)) {
            delete($hash_old{$userid});
        } else {
            delete($hash_old{$prev_userid});
        }
    }
    $prev_userid = $userid;
    $prev_numposting = $numposting;
    $prev_numlogin = $numlogin;
}

while (<STAT_NEW>) {
    chomp;
    ($numposting, $numlogin, $temp, $userid) = /^\s*(\d+)\s*(\d+)\s*(\d+\.\d+)\s*(\S+)$/;

    # 아이디 중복 처리
    if ($userid =~ /\x07/) {
        #print "# $userid\n";
        next;
    }

    $hash_new{$userid} = [$numposting, $numlogin];

    if ($prev_numposting == $numposting and $prev_numlogin == $numlogin) {
        #print "$prev_userid $userid ";
        if (length($prev_userid) <= length($userid)) {
            delete($hash_new{$prev_userid});
            #print "## $prev_userid\n";
        } else {
            delete($hash_new{$userid});
            #print "## $userid\n";
        }
    }
    $prev_userid = $userid;
    $prev_numposting = $numposting;
    $prev_numlogin = $numlogin;
}

foreach $userid (keys %hash_new) {
    #chomp $userid;

    $old_numposting = $hash_old{$userid}[0];
    $old_numlogin = $hash_old{$userid}[1];
    $new_numposting = $hash_new{$userid}[0];
    $new_numlogin = $hash_new{$userid}[1];
    
    $posting_diff = $new_numposting - $old_numposting;
    $login_diff = $new_numlogin - $old_numlogin;

	# 아이디를 새로 만든 게 아니라 프로그램 오류로 지난 달 기록이 없었다면
	# 무시한다.
	if ($old_numlogin == 0) {
		print STAT_EXT "$userid $old_numlogin --> $new_numlogin = $login_diff, $old_numposting --> $new_numposting = $posting_diff\n";
	}
    
    if ($login_diff == 0) {
        next;
    }

    printf("%10s %5d %5d %8.4f\n", $userid, $posting_diff, $login_diff, $posting_diff / $login_diff);
}


