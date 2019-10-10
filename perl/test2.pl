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
    my $map_ref = shift;

    my $file_name = $work_dir . "/" . $tab_name . "_" . $date_str;
    my $clean_keyword = $keyword;
    $clean_keyword = clean($keyword);

    if (!open(IN, $file_name)) {
        print "can't open file '$file_name' for reading, $ERRNO\n";
        return -1;
    }
    while (my $line = <IN>) {
        chomp $line;
        my ($repr, $qc, @assocs) = split /\t/, $line;
        my $clean_repr = clean($repr);
        if ($clean_keyword eq $clean_repr) {
            for (my $i = 0; $i < 10; ++$i) {
                my $assoc = shift @assocs;
                if (not defined $assoc) {
                    last;
                }
                if (defined $map_ref->{$assoc}) {
                    next;
                }
                print $assoc;
                $map_ref->{$assoc} = 1;
                print "\t";
            }
        }
    }
    close(IN);
}


sub search_keyword
{
    my $date_str = shift;
    my $map_ref = shift;

    my $file_name = $work_dir . "/" . $tab_name . "_" . $date_str;
    if (!open(IN, $file_name)) {
        print "can't open file '$file_name' for reading, $ERRNO\n";
        return -1;
    }
    while (my $line = <IN>) {
        chomp $line;
        my ($repr, $qc, @assocs) = split /\t/, $line;
        my $clean_repr = clean($repr);
        $map_ref->{$clean_repr} = $line;
    }
    close(IN);

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

    if (!open(REPR_FILE, $ARGV[0])) {
        print STDERR "can't open '$ARGV[0]' for reading, $ERRNO\n";
        return -1;
    }
    if ($end_ts == $start_ts) {
        # 1일치는 과거 추출 파일을 통째로 읽어서 처리함
        my %repr_assoc_map = ();
        search_keyword(convert_ts_to_str($start_ts), \%repr_assoc_map);
        while (my $repr = <REPR_FILE>) {
            chomp $repr;
            print $repr . "\t";
            my $clean_repr = clean($repr);
            if (exists $repr_assoc_map{$clean_repr}) {
                my $line = $repr_assoc_map{$clean_repr};
                my ($repr, $qc, @assoc_list) = split /\t/, $line;
                my $cnt = 0;
                foreach my $assoc (@assoc_list) {
                    if ($cnt > 9) {
                        last;
                    }
                    print $assoc;
                    if ($cnt < scalar @assoc_list - 1 and $cnt < 9) {
                        print "\t";
                    }
                    ++$cnt;
                }
            }
            print "\n";
        }
    } else {
        while (my $repr = <REPR_FILE>) {
            chomp $repr;
            # 지정된 날짜 구간에 대해
            my %keyword_existence_map = ();
            print "$repr\t";
            for (my $i = 0; $i < ($end_ts - $start_ts) / $SECONDS_PER_DAY + 1; 
                 ++$i) {
                my $ts = $start_ts + $i * $SECONDS_PER_DAY;
                my $date_str = convert_ts_to_str($ts);
                
                search_keyword_and_print($repr, $date_str, 
                                         \%keyword_existence_map);
            }
            print "\n";
        }
    }
    close(REPR_FILE);

    return 0;
}


main();

