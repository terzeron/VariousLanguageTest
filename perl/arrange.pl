#!/usr/bin/env perl

use strict;
use warnings;
use English;
use POSIX qw(strftime);
use File::Path qw(mkpath);


my $WORK_DIR = "/data1/TQL/cluster";
my $day_offset = (scalar @ARGV > 0 ? $ARGV[0] : 1);
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


sub main
{
    my @SOURCE_LIST = ("ad", "assoc", "site", "tseries", "user");
    my @TYPE_LIST = ("t", "tc", "te", "tce", "tcr", "tcre", "e", "et");

    my $date_str = convert_ts_to_str(time() - $SECONDS_PER_DAY * $day_offset);
    my ($year, $mon, $day) = $date_str =~ /(\d\d)(\d\d)(\d\d)/;

    print "$date_str\n";

    foreach my $source (@SOURCE_LIST) {
        $source =~ /^(\w\w)/;
        my $new_source = $1;
        my $path_prefix = $WORK_DIR . "/cluster.ssc/";
        foreach my $type (@TYPE_LIST) {
            my $dir = $path_prefix . $year . "/" . $mon . "/" . $day . "/" . 
                $new_source . "_" . $type;
            if (-e $dir and -e $dir . "/0000.sort") {
                print "$dir\n";
                chdir($dir);
                # 해당 타입의 디렉토리 안에 0000.sort 파일이 존재하면
                my $cmd = "cxx_sorter 0000.sort | uniq > temp.$$ && mv temp.$$ 0000.sort && ~/terzeron/tql/tql_index make $dir && (ln -sf $dir $path_prefix/00/00/00/${new_source}_$type)";
                print "$cmd\n";
                my $result = `$cmd`;
                print $result;
            }
        }
    }
}

main();


