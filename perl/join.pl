#!/usr/bin/env perl

# usage: join.pl 20070623*

# aqc������ aqc���� 5�� summary data�� join�Ͽ�
# �ð� ������ basis ���Ϸ� ������
# * aqc�� �ð� ������ ����ؾ� �ϹǷ� 1/24�� �����

# flush stdout
$| = 1;

foreach $summaryfilename (@ARGV) {
    $summaryfilename =~ /^(\d\d\d\d\d\d\d\d)\d\d$/;
    $aqcfilename = "aqc_" . $1 . ".txt";
    $outfilename = $summaryfilename . ".joined";
    print "aqcfilename=$aqcfilename\n";
    print "outfilename=$outfilename\n";
    open(OUTFILE, ">$outfilename") or die "can't open file '$outfilename'\n";
    
    %hash = ();
    open(AQC, $aqcfilename) or die "can't open file '$aqcfilename'\n";
    while (<AQC>) {
    	chomp;
    	($query, $aqc) = split "\t";
    	#print "$query==>$aqc\n";
    	$hash{$query} = int($aqc / 24);
    }
    close(AQC);
    
    $count = 0;
    $count_intvl = 10000;
    open(SUMMARY, $summaryfilename) or die "can't open file '$summaryfilename'\n";
    while (<SUMMARY>) {
    	chomp;
    	($query, $hour, $qc, $uipcnt) = split "\t";
    	if (not defined $hash{$query} or $hash{$query} eq "") {
	    print OUTFILE $_ . "\t0\t0\n";
    	} else {
	    print OUTFILE $_ . "\t$hash{$query}\t$hash{$query}\n";
    	}
    	if ($count % $count_intvl == $count_intvl - 1) {
	    print "+";
    	}
    	++$count;
    }
    print "\n";
    close(SUMMARY);

    close(OUTFILE);

    rename $summaryfilename . ".joined", $summaryfilename;
}
