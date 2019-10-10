#!/usr/bin/env perl

while (my $line = <>) {
    $decoded = &urldecode($line);
    print "$decoded";
    
    sub urldecode {
    my $string = shift(@_);
    my $decoded;
    
    @list = split //, $string;
    while (($char = shift @list) ne '') {
	if ($char eq '%') {
	$ch1 = shift @list;
	$ch2 = shift @list;
	$decoded .= sprintf "%c", hex("$ch1$ch2");
	} else {
	$char =~ s/\+/ /g;
	$decoded .= $char;
	}
    }
    return $decoded;
    }
}
