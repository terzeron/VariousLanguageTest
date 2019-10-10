#!/usr/local/bin/perl
#
# temp.pl
#
# This script convert text file into html file
# with "<a http://...">...</a>

while (<>) {
  if (/\s-\s/) {
    @field = /(.*)\s-\s(.*)<br>/;
    print "<a href=\"http:\/\/$field[1]\">$field[0]<\/a><br>\n";
  } 
  elsif (/\s*<br>/) {
    ($field[1]) = /\s*(.*)<br>/; 
    print "<a href=\"http:\/\/$field[1]\">$field[0]<\/a><br>\n";
  } 
  elsif (/<p>/) {
    print $_ . "\n";
  }
}
