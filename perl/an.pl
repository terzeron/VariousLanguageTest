#!/usr/bin/env perl

use Time::Local;

my $table_name = "runningtime";
my $runningtime;
my $timestamp;
my @t;
my $home_dir = "/home1/terzeron";
my $sqlite = "$home_dir/sqlite3";
my $db_name = "test";
my $db_file = "$home_dir/$db_name";

open(DB, "| $sqlite $db_file") or
    die "can't open pipe to '$sqlite', $ERRNO\n";
while ($line = <>) {
    if (@t = $line =~ /start time: (\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+)/) {
	while ($line = <>) {
	    if ($line =~ /running time (\d+\.\d+) second\(s\)/) {
		--$t[1];
		$timestamp = timelocal @t[5, 4, 3, 2, 1, 0];
		print DB "insert into $table_name values ($timestamp, $1);\n";
		#print "insert into $table_name values ($timestamp, $1);\n";
		last;	
	    }
	}
    }
}
close(DB);
