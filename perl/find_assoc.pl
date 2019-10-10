#!/usr/bin/env perl

use English;
use warnings;
use strict;
use Getopt::Std;
use POSIX;
use POSIX qw(strftime);

my $tab_name = "nexearch";
my $work_dir = $tab_name;
my $SECONDS_PER_DAY = 60 * 60 * 24;


sub convert_str_to_ts
{
    my $date_str = shift;
    
    my ($year, $mon, $day) = $date_str =~ /(\d\d)(\d\d)(\d\d)/;
    
    return mktime(0, 0, 0, $day, $mon - 1, $year + 1900, 0, 0);
}


sub convert_ts_to_str
{
    my $ts = shift;
    
    return strftime("%y%m%d", localtime($ts));
}


sub clean
{
    my $keyword = shift;
    $keyword =~ tr/A-Z/a-z/;
    $keyword =~ tr/ //d;
    return $keyword;
}

sub search_keyword_and_print
{
    my $keyword = shift;
    my $date_str = shift;
    my $file_name = $work_dir . "/" . $tab_name . "_" . $date_str;

    my $clean_keyword = $keyword;
    $clean_keyword = clean($keyword);

    if (!open(IN, $file_name)) {
        print "can't open file '$file_name' for reading, $ERRNO\n";
        return -1;
    }
    my $out_file_name = $keyword . ".txt";
    if (!open(OUT, ">> $out_file_name")) {
        print "can't open file '$out_file_name' for writing, $ERRNO\n";
        return -1;
    }
    while (my $line = <IN>) {
        chomp $line;
        my ($repr, $qc, @assocs) = split /\t/, $line;
        my $clean_repr = clean($repr);
        if ($clean_keyword eq $clean_repr) {
            print OUT $date_str . "\t" . $repr . "\t" . $qc . "\t";
            for (my $i = 0; $i < 10; ++$i) {
                my $assoc = shift @assocs;
                if (not defined $assoc) {
                    last;
                }
                print OUT $assoc;
                if ($i < 9) {
                    print OUT "\t";
                }
            }
            print OUT "\n";
        }
    }
    close(IN);
    close(OUT);
}


sub main
{
    my %opts = ();
    my $start_date = "";
    my $end_date = "";
    my $start_ts = 0;
    my $end_ts = 0;
    
    # 옵션 처리
    getopt("s:e:", \%opts);
    if (defined $opts{"s"}) {
        $start_date = $opts{"s"};
        $start_ts = convert_str_to_ts($start_date);
    }
    if (defined $opts{"e"}) {
        $end_date = $opts{"e"};
        $end_ts = convert_str_to_ts($end_date);
    }

    if ($start_date eq "" and $end_date eq "") {
        $start_date = convert_ts_to_str(time() - $SECONDS_PER_DAY);
        $start_ts = convert_str_to_ts($start_date);
        $end_date = $start_date;
        $end_ts = $start_ts;
    }
=pod
    print "start_date=$start_date, end_date=$end_date\n";
    print "start_ts=$start_ts, end_ts=$end_ts\n";
    print "start=" . strftime("%y%m%d %H%M%S", localtime($start_ts)) . "\n";
    print "end=" . strftime("%y%m%d %H%M%S", localtime($end_ts)) . "\n";
=cut

    # 모든 argument list로 지정된 검색어에 대해
    for (my $k = 0; $k < scalar @ARGV; ++$k) {
        my $repr = $ARGV[$k];
        # 지정된 날짜 구간에 대해
        for (my $i = 0; $i < ($end_ts - $start_ts) / $SECONDS_PER_DAY + 1; 
             ++$i) {
            my $ts = $start_ts + $i * $SECONDS_PER_DAY;
            my $date_str = convert_ts_to_str($ts);
            
            search_keyword_and_print($repr, $date_str);
        }
        
        # cp949로 파일 이름 변경
        my $result = `echo $repr | iconv -futf8 -tcp949`;
        chomp $result;
        rename "$repr.txt", "$result.txt";
    }
}


main();

