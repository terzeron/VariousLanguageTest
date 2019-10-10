#!/usr/bin/env perl

use strict;
use warnings;
use English;
use POSIX qw(strftime);
use File::Path qw(mkpath);


my $WORK_DIR = "cluster";
my $day_offset = (scalar @ARGV > 0 ? $ARGV[0] : 1); 
my $SECONDS_PER_DAY = 60 * 60 * 24;

my %t_ec_map = ();
my %tc_ec_map = ();
my %te_ec_map = ();
my %tce_ec_map = ();
my %tcr_ec_map = ();
my %tcre_ec_map = ();
my %e_ec_map = ();
my %et_ec_map = ();

my @ad_theme_name_list = 
    ("여성의류", "남성의류/수입캐쥬얼", "아동복", "기타의류",
     "액세서리", "명품/잡화", "미용/성형/다이어트", "건강/음식",
     "국내여행/레저/레저용품", "해외여행", "이벤트/꽃배달/결혼",
     "홍보/기념품/판촉물", "소프트웨어/컴퓨터학원/게임", "하드웨어/컴퓨터수리",
     "인터넷/통신", "교육/외국어/유학", "학위취득/직업교육", "아르바이트/취업",
     "점포창업/요식업", "온라인창업/인터넷광고", "금융상품", "대출", "부동산",
     "법률/비즈니스/정치", "인테리어/리모델링", "생활용품/사무기기", 
     "생활서비스", "이사/운송/물류", "취미/오락", "운세/작명", "산업/기계",
     "자동차/중고차/부품", "성인");
my @as_si_theme_name_list =
    ("대중음악", "방송/연예", "영화", "만화/인터넷소설", "게임", "스포츠",
     "얼짱/모델", "의류/잡화", "유아/아동용품", "생활용품/인테리어", 
     "전자기기/컴퓨터", "자동차", "이벤트/판촉/결혼", "미용/다이어트",
     "건강", "여행", "요리/맛집", "로또/경마/운세", "취미", "교육/대학",
     "어학/자격증", "소프트웨어", "아르바이트/취업", "단어검색", "정보검색",
     "생활정보/기관단체", "시사/미디어/포털", "금융/비즈니스/법률", 
     "생활서비스/통신", "산업용품", "성인");
                      

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


sub read_and_count
{
    my $source = shift;
    my $date_str = shift;

    print "# read_and_count($source, $date_str)\n";
    
    my $file_name = "";
    if ($source ne "user") {
        $file_name = $source . "/" . $date_str . ".converted";
    } else {
        $file_name = `ls ${source}/class.*_*${date_str}.converted`;
        chomp $file_name;
    }
    
    if (!open(INFILE, $file_name)) {
        print STDERR "can't open file '$file_name' for reading, $ERRNO\n";
        return -1;
    }
    my $theme = "";
    my $cluster = "";
    my $repr = "";
    my @element_list;
    while (my $line = <INFILE>) {
        chomp $line;
        #print "line=$line\n";
        if ($line =~ /^\#\[?\s+Cluster\s+(\S+)\s+\([^\)]+\)\s+:\s+([^, ]+)/) {
            # theme information
            if ($source ne "user") {
                $theme = $1;
            } else {
                $theme = $2;
            }
            if ($source eq "ad") {
                $theme = $ad_theme_name_list[$theme - 1];
            } elsif ($source eq "assoc" or $source eq "site") {
                $theme = $as_si_theme_name_list[$theme - 1];
            }
            #print "theme=$theme\n";
        } elsif ($line =~ /^\#cluster\s+(\S+)\s+\S+$/) {
            $theme = $1;
            #print "theme=$theme\n";
        } else {
            # cluster & elements information
            my $cluster_desc = "";
            ($cluster_desc, @element_list) = split /\t/, $line;
            if ($source eq "site") {
                my $cluster_desc_url = shift @element_list;
                $cluster_desc = $cluster_desc . "," . $cluster_desc_url;
                my @new_element_list = ();
                while (scalar @element_list >= 2) {
                    my $first = shift @element_list;
                    my $second = shift @element_list;
                    push @new_element_list, $first . "," . $second;
                }
                @element_list = @new_element_list;
            }
            #print "cluster_desc=$cluster_desc\n";
            #print "element_list=@element_list\n";
            if ($cluster_desc =~ /^([^-]*)-(?:[^-]+-)?(.*)$/) {
                $cluster = $1;
                $repr = $2;
            }
            #print "cluster=$cluster\n";
            #print "repr=$repr\n";
            #print "element_list=@element_list\n";
        }

        # 집계
        $t_ec_map{$theme} += scalar @element_list;
        $tc_ec_map{"$theme\t$cluster"} += scalar @element_list;
        if ($source eq "ad" or $source eq "assoc" or $source eq "site") {
            $tcr_ec_map{"$theme\t$cluster\t$repr"} += scalar @element_list;
        }
        
        foreach my $element (@element_list) {
            $te_ec_map{"$theme\t$element"}++;
            $tce_ec_map{"$theme\t$cluster\t$element"}++;
            if ($source eq "ad" or $source eq "assoc" or $source eq "site") {
                $tcre_ec_map{"$theme\t$cluster\t$repr\t$element"}++;
            }

            $e_ec_map{$element}++;
            $et_ec_map{"$element\t$theme"}++;
        }
    }
    close(INFILE);
    
    return 0;
}


sub make_summary_file
{
    my $source = shift;
    my $date_str = shift;

    print "# make_summary_file($source, $date_str)\n";
    
    my ($year, $mon, $day) = $date_str =~ /(\d\d)(\d\d)(\d\d)/;
    my $path_prefix = "/data1/TQL/cluster/cluster.ssc/" . 
        $year . "/" . $mon . "/" . $day . "/";

    my $new_source = "";
    if ($source =~ /^(\w\w)/) {
        $new_source = $1;
    }

    my $dir;
    my $file_name;

    $dir = $path_prefix . "/" . $new_source . "_t";
    $file_name = $dir . "/0000.sort";
    mkpath($dir);
    if (!open(OUTFILE1, "> $file_name")) {
        print STDERR "can't open '$file_name' for writing, $ERRNO\n";
        return -1;
    }
    $dir = $path_prefix . "/" . $new_source . "_tc";
    $file_name = $dir . "/0000.sort";
    mkpath($dir);
    if (!open(OUTFILE2, "> $file_name")) {
        print STDERR "can't open '$file_name' for writing, $ERRNO\n";
        return -1;
    } 
    $dir = $path_prefix . "/" . $new_source . "_te";
    $file_name = $dir . "/0000.sort";
    mkpath($dir);
    if (!open(OUTFILE3, "> $file_name")) {
        print STDERR "can't open '$file_name' for writing, $ERRNO\n";
        return -1;
    }
    $dir = $path_prefix . "/" . $new_source . "_tce";
    $file_name = $dir . "/0000.sort";
    mkpath($dir);
    if (!open(OUTFILE4, "> $file_name")) {
        print STDERR "can't open '$file_name' for writing, $ERRNO\n";
        return -1;
    }
    $dir = $path_prefix . "/" . $new_source . "_tcr";
    $file_name = $dir . "/0000.sort";
    mkpath($dir);
    if (!open(OUTFILE5, "> $file_name")) {
        print STDERR "can't open '$file_name' for writing, $ERRNO\n";
        return -1;
    }
    if ($source eq "ad" or $source eq "assoc" or $source eq "site") {
        $dir = $path_prefix . "/" . $new_source . "_tcre";
        $file_name = $dir . "/0000.sort";
        mkpath($dir);
        if (!open(OUTFILE6, "> $file_name")) {
            print STDERR "can't open '$file_name' for writing, $ERRNO\n";
            return -1;
        }
    }
    $dir = $path_prefix . "/" . $new_source . "_e";
    $file_name = $dir . "/0000.sort";
    mkpath($dir);
    if (!open(OUTFILE7, "> $file_name")) {
        print STDERR "can't open '$file_name' for writing, $ERRNO\n";
        return -1;
    }
    $dir = $path_prefix . "/" . $new_source . "_et";
    $file_name = $dir . "/0000.sort";
    mkpath($dir);
    if (!open(OUTFILE8, "> $file_name")) {
        print STDERR "can't open '$file_name' for writing, $ERRNO\n";
        return -1;
    }

    my $sum = 0;
    foreach my $key (keys %t_ec_map) {
        #print $key . "\t" . $t_ec_map{$key} . "\n";
        print OUTFILE1 $key . "\t" . $t_ec_map{$key} . "\n";
        $sum += $t_ec_map{$key};
    }
    #print "sum=$sum\n";
    
    $sum = 0;
    foreach my $key (keys %tc_ec_map) {
        #print $key . "\t" . $tc_ec_map{$key} . "\n";
        print OUTFILE2 $key . "\t" . $tc_ec_map{$key} . "\n";
        $sum += $tc_ec_map{$key};
    }
    #print "sum=$sum\n";
    
    $sum = 0;
    foreach my $key (keys %te_ec_map) {
        #print $key . "\t" . $te_ec_map{$key} . "\n";
        print OUTFILE3 $key . "\t" . $te_ec_map{$key} . "\n";
        $sum += $te_ec_map{$key};
    }
    #print "sum=$sum\n";
    
    $sum = 0;
    foreach my $key (keys %tce_ec_map) {
        #print $key . "\t" . $tce_ec_map{$key} . "\n";
        print OUTFILE4 $key . "\t" . 
            $tce_ec_map{$key} . "\n";
        $sum += $tce_ec_map{$key};
    }
    #print "sum=$sum\n";
    
    $sum = 0;
    foreach my $key (keys %tcr_ec_map) {
        #print $key . "\t" . $tcr_ec_map{$key} . "\n";
        print OUTFILE5 $key . "\t" . $tcr_ec_map{$key} . "\n";
        $sum += $tcr_ec_map{$key};
    }
    #print "sum=$sum\n";

    $sum = 0;
    foreach my $key (keys %tcre_ec_map) {
        #print $key . "\t" . $tcre_ec_map{$key} . "\n";
        print OUTFILE6 $key . "\t" . $tcre_ec_map{$key} . "\n";
        $sum += $tcre_ec_map{$key};
    }
    #print "sum=$sum\n";

    $sum = 0;
    foreach my $key (keys %e_ec_map) {
        #print $key . "\t" . $e_ec_map{$key} . "\n";
        print OUTFILE7 $key . "\t" . $e_ec_map{$key} . "\n";
        $sum += $e_ec_map{$key};
    }
    #print "sum=$sum\n";

    $sum = 0;
    foreach my $key (keys %et_ec_map) {
        #print $key . "\t" . $et_ec_map{$key} . "\n";
        print OUTFILE8 $key . "\t" . $et_ec_map{$key} . "\n";
        $sum += $et_ec_map{$key};
    }
    #print "sum=$sum\n";

    close(OUTFILE1);
    close(OUTFILE2);
    close(OUTFILE3);
    close(OUTFILE4);
    close(OUTFILE5);
    close(OUTFILE6);
    close(OUTFILE7);
    close(OUTFILE8);

    return 0;
}


sub main
{
    print "# main()\n";

    chdir $WORK_DIR;

    my @source_list = ("ad", "assoc", "site", "tseries", "user");
    if (scalar @ARGV > 1) {
        shift @ARGV;
        @source_list = @ARGV;
    }
    my $date_str = convert_ts_to_str(time() - $SECONDS_PER_DAY * $day_offset);
    
    print "$date_str\n";

    foreach my $source (@source_list) {
        %t_ec_map = ();
        %tc_ec_map = ();
        %te_ec_map = ();
        %tce_ec_map = ();
        %tcr_ec_map = ();
        %tcre_ec_map = ();
        %e_ec_map = ();
        %et_ec_map = ();
        
        if (read_and_count($source, $date_str) < 0) {
            print STDERR "can't read and count the cluster data, $ERRNO\n";
            next;
        }

        if (make_summary_file($source, $date_str) < 0) {
            print STDERR "can't make summary file, $ERRNO\n";
            next;
        }
    }

    return 0;
}


main();
