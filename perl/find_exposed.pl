#!/usr/bin/env perl

use strict;
use warnings;
use English;

my $keyword = $ARGV[0];

# collect files
my $dirname = "/home1/terzeron/news";
chdir $dirname;
if (!opendir(DIR, $dirname)) {
    print STDERR "can't open directory $dirname, $ERRNO\n";
    exit(-1);
}
my @file_list = ();
while ((my $file = readdir(DIR))) {
    if (not defined $file or $file eq "." or $file eq "..") {
        next;
    }
    if ($file =~ m/^news_20\d+$/) {
        push @file_list, $file;
    }
}
closedir(DIR);

foreach my $file (sort @file_list) {
    if (!open(FILE, $file)) {
        print STDERR "can't open file $file, $ERRNO\n";
        exit(-1);
    }
    my $rank_num = 0;
    while (my $line = <FILE>) {
        chomp $line;
        my @list = split /\t/, $line;
        if ($list[1] == "0") {
            ++$rank_num;
        } else {
            next;
        }
        
        if ($list[0] eq $keyword) {
            print "$file\t$rank_num\t$list[0]\n";
        }

        #if ($rank_num >= 10) {
            #last;
        #}
    }
    close(FILE);
}
