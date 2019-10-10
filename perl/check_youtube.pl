#!/usr/bin/perl -I/home1/terzeron/lib

use strict;
use English;
use LWP::Simple;
use Net::Telnet;

sub mail_to_me
{
    my $subject = shift;
    my $body = shift;

    my $t;
    my $smtp_server = "mail.nhncorp.com";
    my $sender = "terzeron\@nhncorp.com";
    my $receiver = "terzeron\@nhncorp.com";
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
}

sub main
{
    my $subject = "YouTube embeding error";
    my $body = "The YouTube code isn't embedded .\n";

    my $cmd = "rm -f test.php; wget -q http://d79831.nhncorp.com/lyrics/test.php";
    my $result = `$cmd`;
    if ($CHILD_ERROR != 0) {
        print STDERR "can't execute wget\n";
        mail_to_me($subject, "can't execute wget\n");
        return -1;
    }
    if (!open(FILE, "test.php")) {
        print STDERR "can't open file 'test.php'\n";
        mail_to_me($subject, "can't open file 'test.php'\n");
        return -1;
    }
    my $status = 0;
    while (my $line = <FILE>) {
        if ($line =~ /^\<embed /) {
            $status = 1;
        }
    }
    close(FILE);
    
    if ($status == 0) {
        print STDERR "The YouTube code isn't embedded.\n";
        mail_to_me($subject, "The YouTube code isn't embedded.\n");
        return -1;
    }

    return 0;
}

main();
