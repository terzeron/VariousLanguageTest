#!/usr/bin/env perl

use strict;
use warnings;
use English;


sub print_debug
{
    my $arg = shift;
    print $arg;
}


sub mail_to_user
{
    use Net::Telnet;

    my $subject = shift;
    my $body = shift;
    my $mail_conf = shift;

    print_debug("# mail_to_user($mail_conf)\n");

    my $smtp_server = $mail_conf->{'smtp_server'};
    my $sender_addr = $mail_conf->{'sender_addr'};
    my $arg = $mail_conf->{'receiver_addr_list'};
    my @receiver_addr_list = @$arg;

    foreach my $receiver_addr (@receiver_addr_list) {
        my $t = new Net::Telnet(Host => $smtp_server, Port => 25, 
                                Timeout => 10);
        print_debug($t->getline);
        
        $t->put("HELO $smtp_server\n");
        print_debug($t->getline);
        $t->put("MAIL FROM: <$sender_addr>\n");
        print_debug($t->getline);
        $t->put("RCPT TO: <$receiver_addr>\n");
        print_debug($t->getline);
        $t->put("DATA\n");
        print_debug($t->getline);
        $t->put("From: <$sender_addr>\n");
        $t->put("To: <$receiver_addr>\n");
        $t->put("Subject: $subject\n\n");
        $t->put("$body\n");
        $t->put(".\n");
        print_debug($t->getline);
        $t->print("QUIT\n");
        print_debug($t->getline);
        $t->close;
    }

    return 0;
}


sub main
{
    my $hostname = `hostname`; # hard-coded for performance
    chomp $hostname;
    my $subject = "system load check in $hostname";
    my $message = "";
    my @receiver_addr_list = ('terzeron@nhncorp.com', 'chang@nhncorp.com');
    my %mail_conf = ("smtp_server" => "smail01.nhncorp.com",
                     "sender_addr" => "terzeron\@nhncorp.com",
                     "receiver_addr_list" => \@receiver_addr_list);
    
    my $cmd = "uptime";
    my $result = `$cmd`;
    if ($CHILD_ERROR != 0) {
        $message = "can't execute '$cmd', $ERRNO\n";
        mail_to_user($subject, $message, \%mail_conf);
        return -1;
    }
    
    $result =~ /load average: (\d+\.\d+),\s*(\d+\.\d+),\s*(\d+\.\d+)/;
    my $load_1min = $1;
    my $load_5min = $2;
    my $load_15min = $3;
    
    if ($load_1min > 16.0 or $load_5min > 16.0 or $load_15min > 16.0) {
        $message = "too high load: $load_1min, $load_5min, $load_15min\n\n";
        $message .= `ps -ef`;
        mail_to_user($subject, $message, \%mail_conf);
        return -1;
    }
    print "Ok: low load: $load_1min, $load_5min, $load_15min\n";
    return 0;
}

main();
