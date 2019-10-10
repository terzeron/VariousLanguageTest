#!/usr/bin/env perl

use strict;
use English;

#my @keyword_list = ("�򸶸� ���", "���׸�ó��", "��ҿ�", "�򸶸�", "�¿ջ�ű� ���", "�¿ջ�ű� 8ȸ", "���Ŀ¶���2", "�⹫��Ÿ���", "�λ걹����ȭ��", "�̷���", "�°��ӳ�", "�����ɽ� �ڹ�", "������� ����ī", "�ູ", "�Ƹ�����Ʈõ��", "�˹�", "�ڹ�", "�Ƹ�����Ʈ", "�ڹο�", "�������÷�������", "����", "����", "�˹ٸ�", "������ī", "�����", "�˸�����", "�ҳ�ô�", "�ǵ�ڽ�", "��ī", "�Ϳ��κ�");
#my @keyword_list = ("�ȳ� ���� ���̽�", "�򸶸� ���", "�ѳ���", "��ҿ�", "�� ����", "�򸶸�", "���׸�ó��", "wcg", "���Ŀ¶���2", "��ο�");
#my @keyword_list = ("�� ����", "�¿ջ�ű� 8ȸ", "���Ŀ¶���2", "�λ걹����ȭ��", "�˹�", "�ǵ�ڽ�", "�Ƹ�����Ʈ", "¯����", "¯����", "�ູ");
my @keyword_list = ("�� ����", "�ѳ���", "wcg2007", "wcg", "�򸶸� ���", "�ȳ� ���� ���̽�", "��ҿ�", "���׸�ó��", "������", "�򸶸�", "���� �հ���");

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

		 
