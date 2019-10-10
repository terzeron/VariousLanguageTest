#!/usr/bin/perl -I/home1/terzeron/lib

use strict;
use English;
use LWP::Simple;
use Net::Telnet;

my $result;
my $site = "http://terzeron.net";
my $url = "$site/throttle-me";
my $filename = "index.php";
my $sent_size = 0;
my $threshold = 300 * 1024; # 200MB
my $status;

# check the traffic
#$result = `wget $url`;
#print $result;
$status = getstore($url, $filename);
print "got the index page\n" if is_success($status);

# analyze
open(FILE, $filename) or die "can't open file '$filename', $!\n";
while (<FILE>) {
	if (/\<td class="green"\>(\d+)\<\/td\>/) {
		print "size: $1\n";
		if ($sent_size < $1) {
			$sent_size = $1;
		}
	}
}
close(FILE);
$result = `/bin/rm -f $filename`;
print $result;

print "sent_size: $sent_size KB\n";
if ($sent_size < $threshold) {
	print "quit\n";
	exit(0);
}

# notify me
my $t;
my $smtp_server = "mail.nhncorp.com";
my $sender = "terzeron\@nhncorp.com";
my $receiver = "terzeron\@gmail.com";
my $subject = "Traffic jam at $site";
my $body = "The traffic is very high($sent_size) at $site .\n";
my @output;

$t = new Net::Telnet(Host => $smtp_server, Port => 25, Timeout => 10);
print $t->getline;

print "HELO mail.nhncorp.com\n";
$t->put("HELO mail.nhncorp.com\n");
print $t->getline;
print "MAIL FROM:<$sender>\n";
$t->put("MAIL FROM:<$sender>\n");
print $t->getline;
print "RCPT TO:<$receiver>\n";
$t->put("RCPT TO:<$receiver>\n");
print $t->getline;
$t->put("DATA\n");
print "DATA\n";
print $t->getline;
$t->put("From: terzeron <$sender>\n");
$t->put("To: terzeron <$receiver>\n");
$t->put("Subject: $subject\n\n");
$t->put("$body\n");
print "From: terzeron <$sender>\n";
print "To: terzeron <$receiver>\n";
print "Subject: $subject\n\n";
print "$body\n";
$t->put(".\n");
print $t->getline;
$t->print("QUIT\n");
print $t->getline;
$t->close;
print "sent mail to $receiver\n";

