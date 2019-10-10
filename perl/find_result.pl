#!/usr/bin/env perl

use strict;
use English;

#my @keyword_list = ("빅마마 배반", "마그마처럼", "김소연", "빅마마", "태왕사신기 결방", "태왕사신기 8회", "피파온라인2", "기무라타쿠야", "부산국제영화제", "이랜드", "온게임넷", "원더걸스 텔미", "사와지리 에리카", "행복", "아르바이트천국", "알바", "텔미", "아르바이트", "박민영", "리니지플레이포럼", "벅스", "알집", "알바몬", "아프리카", "사람인", "팝리니지", "소녀시대", "피디박스", "엔카", "와우인벤");
#my @keyword_list = ("안나 니콜 스미스", "빅마마 배반", "한나래", "김소연", "더 웨이", "빅마마", "마그마처럼", "wcg", "피파온라인2", "김민우");
#my @keyword_list = ("더 웨이", "태왕사신기 8회", "피파온라인2", "부산국제영화제", "알바", "피디박스", "아르바이트", "짱공유", "짱파일", "행복");
my @keyword_list = ("더 웨이", "한나래", "wcg2007", "wcg", "빅마마 배반", "안나 니콜 스미스", "김소연", "마그마처럼", "김지혜", "빅마마", "에바 롱고리아");

my $keyword_list_size = scalar(@keyword_list);
print "$keyword_list_size\n";

#my $tab_name = "news";
my @tab_name_list = ("nexearch", "news", "cafeblog", "kin", "web", "image", "dic", "video", "music", "nhn");
my $tab_name;
my $result_dir_prefix = "result";
my $result_dir_path;
my $file;
my $i = 0;
my $line;
my @result_data_list;

foreach $tab_name (@tab_name_list) {
    print "$tab_name\n";
    $result_dir_path = $result_dir_prefix . "/" . $tab_name;
    
    opendir(DIR, $result_dir_path);
    while ($file = readdir(DIR)) {
	if ($file eq "." or $file eq "..") {
	    next;
	}
	if ($file =~ /\.gz$/) {
            next;
        }
	#print "$file\n";
	open(FILE, $result_dir_path . "/" . $file);
	$i = 0;
	@result_data_list = ();
	while ($line = <FILE>) {
	    chomp $line;
	    @result_data_list = split(/\t/, $line);
	    if ($result_data_list[0] ne $keyword_list[$i]) {
		last;
	    }
	    #print "$result_data_list[0]\n";
	    ++$i;
	}
	if ($i == $keyword_list_size) {
	    print "#$file\n";
	}
	close(FILE);
    }
    closedir(DIR);
}

		 
