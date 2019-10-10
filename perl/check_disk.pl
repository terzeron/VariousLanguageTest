#!/usr/bin/env perl

use strict;
use warnings;
use English;
use Net::Telnet;


my $work_dir = "check_disk";
my $file_prefix = "daily_df.";

sub get_file_name
{
    my $SECONDS_PER_DAY = 60 * 60 * 24;
    my $eTime;
    my $file;

    $eTime = time - $SECONDS_PER_DAY * $_[0];
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) =
        localtime($eTime);
    $year -= 100;
    $mon += 1;
    $file = sprintf("%02d%02d%02d", $year, $mon, $mday);

    return $file;
}


sub write_daily_log
{
    my $cmd;
    my $result;
    my $output_file;

    $output_file = "$work_dir/$file_prefix" . get_file_name(0);
    if (!open(OUT, "> $output_file")) {
	print STDERR "can't open '$output_file' for writing, $ERRNO\n";
	return -1;
    }
	    
    $cmd="df -k";
    $result=`$cmd`;
    foreach my $line (split /\n/, $result) {
	my $percentage;
	my $mount_point;
	my $used;
	my $avail;
	
	#print "$line\n";
	if ($line =~ m!(\S+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\%\s+(\S+)$!) {
            $used = $3;
            $avail = $4;
            $mount_point = $6;
            if ($mount_point eq "/" or $mount_point eq "/home1") {
                $percentage = $used * 100 / ($used + $avail);
                print OUT "$mount_point\t$used\t$avail\t$percentage\n";
            }
        }
    }
    
    close(OUT);
}


sub mail_to_user
{
    my $subject = shift;
    my $body = shift;
    my $mail_conf = shift;
    my $t;

    print "# mail_to_user($mail_conf)\n";

    my $smtp_server = $mail_conf->{'smtp_server'};
    my $sender_addr = $mail_conf->{'sender_addr'};
    my $sender_name = $mail_conf->{'sender_name'};
    my $receiver_addr = $mail_conf->{'receiver_addr'};
    my $receiver_name = $mail_conf->{'receiver_name'};

    $t = new Net::Telnet(Host => $smtp_server, Port => 25, Timeout => 10);
    print $t->getline;

    $t->put("HELO $smtp_server\n");
    print $t->getline;
    $t->put("MAIL FROM:<$sender_addr>\n");
    print $t->getline;
    $t->put("RCPT TO:<$receiver_addr>\n");
    print $t->getline;
    $t->put("DATA\n");
    print $t->getline;
    $t->put("From: $sender_name <$sender_addr>\n");
    $t->put("To: $receiver_name <$receiver_addr>\n");
    $t->put("Subject: $subject\n\n");
    $t->put("$body\n");
    $t->put(".\n");
    print $body;
    print $t->getline;
    $t->print("QUIT\n");
    print $t->getline;
    $t->close;

    return 0;
}


sub check_diff
{
    my $today_file = get_file_name(0);
    my $yesterday_file = get_file_name(1);
    my $output_file;
    my %yesterday_mp_percentage = ();
    my %mail_conf = ("smtp_server" => "smail01.nhncorp.com",
		     "sender_name" => "Young-il Cho",
		     "sender_addr" => "terzeron\@nhncorp.com",
		     "receiver_name" => "Young-il Cho",
		     "receiver_addr" => "terzeron\@nhncorp.com");
    my $host_name = `hostname`;
    chomp $host_name;
    my $subject = "Disk usage warning report at $host_name";
    my $body;

    $output_file = "$work_dir/$file_prefix" . $today_file;
    if (!open(F1, $output_file)) {
	print STDERR "can't open '$output_file' for reading, $ERRNO\n";
	return -1;
    }
    while (<F1>) {
	my ($mount_point, $used, $avail, $percentage) = split /\t/;
	$yesterday_mp_percentage{$mount_point} = $percentage;
	#print "$mount_point, $used, $avail, $percentage\n";
    }
    close(F1);

    $output_file = "$work_dir/$file_prefix" . $yesterday_file;
    if (!open(F2, $output_file)) {
	print STDERR "can't open '$output_file' for reading, $ERRNO\n";
	return -1;
    }
    while (my $line = <F2>) {
        chomp $line;
	my ($mount_point, $used, $avail, $percentage) = split /\t/, $line;
	#print "$mount_point, $used, $avail, $percentage\n";
	if ($percentage >= 98.0) {
	    $body = "Disk usage is too dangerously big, $percentage\%.\n";
	    $body .= "Need to attach new disk to this host.\n";
	    mail_to_user($subject, $body, \%mail_conf);
	} elsif ($percentage >= 90.0) {
	    $body = "Disk usage is too big, $percentage\%.\n";
	    $body .= "Need to delete unnecesarry data files.\n";
	    mail_to_user($subject, $body, \%mail_conf);
	} elsif ($percentage > 
		 $yesterday_mp_percentage{$mount_point} * 1.01)  {
	    $body = "Disk usage became bigger than ";
	    $body .= "that of yesterday abruptly\n";
	    $body .= $yesterday_mp_percentage{$mount_point} . " --> " .
		$percentage . "\n";
            $body .= "Need to check newly created files.\n";
            mail_to_user($subject, $body, \%mail_conf); 
	} else {
	    print "Ok\n";
	}
    }
    close(F2);
    
}


sub main
{
    write_daily_log();
    check_diff();
}


main();
