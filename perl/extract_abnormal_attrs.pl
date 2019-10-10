#!/usr/bin/env perl
#-*- coding: utf_8 -*-

use English;
use strict;
use POSIX qw(strftime);

sub main() {
    my $node_files;
    my $node_file;
    my %attrname_cnt_map;
    my %nodename_coordinate_map;
    my $nodename;

    $node_files = `ls attr_list.*`;
    foreach $node_file (split /\n/, $node_files) {
	my ($node_file_num) = $node_file =~ /\.(\d+)$/o;
	$nodename = `grep \"^$node_file_num \" numbered_sp_list | cut -d\" \" -f2`;
	chomp $nodename;

	open(NODE_FILE, $node_file) or die "can't open $node_file, $ERRNO\n";
	%attrname_cnt_map = ();

	# collect the basic statistics
	while (<NODE_FILE>) {
	    my ($attr_cnt, $attrname) = /^\s*(\d+)\s+(.+)$/o;
	    # HASH name_cnt_map: name --> cnt
	    $attrname_cnt_map{$attrname} = $attr_cnt;
	    #print "name:$attrname, cnt:$attr_cnt\n";
	}

	# calculate the standard coordinate
	my $sp_cnt = $attrname_cnt_map{'sp'};
	my $attrname;
	#print "(";
	my %attrname_coord_map = ();
	foreach $attrname (sort keys %attrname_cnt_map) {
	    # LIST coordinate: ratio of # of occurrence of an attribute
	    $attrname_coord_map{$attrname} = 
		$attrname_cnt_map{$attrname} / $sp_cnt;
	}
	#print ")\n";

	# HASH nodename_coordinate_map: node name --> coordinate
	#print "@coordinate\n";
	$nodename_coordinate_map{$nodename} = \%attrname_coord_map;

	close(NODE_FILE);
	#print "\n";
    } # foreach loop
    
    # test code
    foreach $nodename (sort keys %nodename_coordinate_map) {
	my $coord = $nodename_coordinate_map{$nodename};
	my %name_coord_map = %{$coord};
	#print "$nodename: (";
	my $name;
	foreach $name (sort keys %name_coord_map) {
	    #print $name . "=>" . $name_coord_map{$name} . ", ";
	}
	#print ")\n";
    }
    
    my $date_str = strftime "%Y%m%d", localtime;
    #my $log_file = "abnormal_nodes." . $date_str;
    my $log_file = $ARGV[0];
    my @matched_name_value_list;
    open(LOG_FILE, $log_file) or die "can't open $log_file, $ERRNO\n";
    while (<LOG_FILE>) {
	@matched_name_value_list = $_ =~ m/([^>= ]+)=([^\> ]*)/go;
	my $i = 0;
	my %this_name_coord_map;
	my $attr;
	my $name;
	my $nodename;
	foreach $attr (@matched_name_value_list) {
	    if ($i % 2 == 0) {
		$name = $attr;
	    } else {
		$this_name_coord_map{$name} = 1;
		#print "$name: $attr\n";
		if ($name eq "sp") {
		    $nodename = $attr;
		}
	    }
	    $i++;
	}
	
	my $coord = $nodename_coordinate_map{$nodename};
	print $nodename . " ";
	if (!defined $coord) {
	    print "--- has been made newly ---\n";
	    next;
	}
	my %std_name_coord_map = %{$coord};
	my $attrname;
	my $sqr_sum = 0.0;
	foreach $attrname (sort keys %std_name_coord_map) {
	    #print $attrname . ":" . $this_name_coord_map{$attrname} . "-" . $name_coord_map{$attrname} . ", ";
	    $sqr_sum += ($this_name_coord_map{$attrname} - $std_name_coord_map{$attrname}) ** 2;
	}
	#print "\n";
	if (sqrt($sqr_sum) >= 1.0) {
	    #print "$nodename ";
	    print sqrt($sqr_sum);
	    print " ";
	    my $attrname;
	    foreach $attrname (sort keys %std_name_coord_map) {
		if ($this_name_coord_map{$attrname} == 0 and
		    $std_name_coord_map{$attrname} >= 0.0001) {
		    # NE(non-existent): 표준 노드에는 지정되어 있는데 
		    # 이 노드에는 빠진 애트리뷰트
		    # TODO: 모두 출력하지 말고 정상인데 로그에서 빠진 
		    #       애트리뷰트만 출력하도록 변경할 것
		    print "$attrname(NE) ";
		}
	    }
	    foreach $attrname (sort keys %this_name_coord_map) {
		if ($std_name_coord_map{$attrname} < 0.1) {
		    # NS(not-specified): 표준 노드에 지정되지 않은 애트리뷰트
		    print "$attrname(NS) ";
		}
	    }
	    print "\n";
	} else {
	    print sqrt($sqr_sum)  . " --- This node is located with the standard coordinate much closely. ---\n";
	}

	# calculate the distance of this coordinate and the standard coordinate
    }
    close(LOG_FILE);
}

main();
