#!/usr/bin/env perl

while (my $line = <>) {
    chomp $line;
    my ($repr, $assocs) = split /:/, $line;
    if ($repr eq "º≠∫Œ»Ò") {
	print $ARGV[0] . "\t";
	print $line . "\n";
	next;
    }

    my @list = split /\^/, $assocs;
    foreach my $assoc (@list) {
	if ($assoc eq "º≠∫Œ»Ò") {
	    print $ARGV[0] . "\t";
	    print $line . "\n";
	    last;
	}
    } 
}
