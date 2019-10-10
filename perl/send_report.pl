#!/usr/bin/perl -I /home1/terzeron/lib

use strict;
use English;
#use LWP::Simple;
use Net::Telnet;
use File::stat;

my $result_str = "";

sub check_file 
{
    my $today_file = shift;
    my $yesterday_file = shift;

    if (not -f $today_file) {
	$result_str .= "$today_file: not found\n";
	return -1;
    }

    if (not -f $yesterday_file) {
	$result_str .=  "$yesterday_file: not found\n";
	return -1;
    }

    my $st1 = stat($today_file);
    my $size1 = $st1->size;
    my $mtime1 = $st1->mtime;
    my $st2 = stat($yesterday_file);
    my $size2 = $st2->size;
    my $current_timestamp = time();
    
    if ($size1 == 0 or $size1 < $size2 * 0.80) {
	$result_str .= "$today_file: smaller size than yesterday, $size1 = $size2 * " . int($size1*100/$size2) . "%\n";
	return -1;
    }
    my ($sec1, $min1, $hour1, $mday1, $mon1, $year1, $wday1, $yday1, $isdst1) =
	localtime($mtime1);
    #print "$year1-$mon1-$mday1\t";
    my ($sec2, $min2, $hour2, $mday2, $mon2, $year2, $wday2, $yday2, $isdst2) =
	localtime($current_timestamp);
    #print "$year2-$mon2-$mday2\n";
    
    if ($mday1 != $mday2 or $mon1 != $mon2 or $year1 != $year2) {
	$result_str .= "$today_file: different mtime, $year1-$mon1-$mday1\n";
	return -1;
    }

    return 0;
}


sub send_message
{
    my $t = shift;
    my $message = shift;

    print $message;
    $t->put($message);
}


sub main
{
    my $result = "";
    my $date1_str;
    my $date2_str;
    my $host_name = `hostname`;
    chomp $host_name;
    my $work_dir = "laurel";
    my @service1_list = ("nexearch", "webkr", "kin", "image", "news",
			 "blog", "dic", "music", "video", "cafe", "site",
			 "jr", "tx_movie", "tx_people", "tx_people_new", 
			 "tx_car", "tx_game", "tx_health");
    my @service2_list = ("nexearch", "webkr", "kin", "image", "news", "blog", 
			 "dic", "music", "video", "cafe", "site", "jr");
    my $num_service1_list = scalar @service1_list;
    my $num_service2_list = scalar @service2_list;
    my $today_file; 
    my $yesterday_file;
    my @error_file_list = ();
    my $num_files = 0;

    chdir $work_dir;

    $result = `date +"%y%m%d" --date yesterday`;
    chomp $result;
    $date1_str = $result;
    $result = `date +"%y%m%d" --date "-2 day"`;
    chomp $result;
    $date2_str = $result;
    
    print $date1_str . "\n";

    $result = $host_name . "\t" . $work_dir . "\n\n";
    $result .= "====================\n";
    $result .= "====== result ======\n";
    $result .= "====================\n";
    $result .= "====== checking today input files (YYMMDD) ======\n";
    $num_files = 0;
    @error_file_list = ();
    foreach my $service (@service2_list) {
	$today_file = "${service}/${date1_str}";
	$yesterday_file = "${service}/${date2_str}";
	if (check_file($today_file, $yesterday_file) == 0) {
	    ++$num_files;
	} else {
	    push @error_file_list, $today_file;
	}
    }
    if ($num_files == $num_service2_list) {
	$result .= "Ok\n";
    } else {
	$result .= "NOT Ok, $num_files, @error_file_list\n";
    }
    
    $result .= "====== checking today result files (YYMMDD.result) ======\n";
    $num_files = 0;
    @error_file_list = ();
    foreach my $service (@service2_list) {
	$today_file = "${service}/${date1_str}.result";
	$yesterday_file = "${service}/${date2_str}.result";
	if (check_file($today_file, $yesterday_file) == 0) {
	    ++$num_files;
	} else {
	    push @error_file_list, $today_file;
	}
    }
    if ($num_files == $num_service2_list) {
	$result .= "Ok\n";
    } else {
	$result .= "NOT Ok, $num_files, @error_file_list\n";
    }
    
    $result .= "====== checking mid result files (assoc_mid) ======\n";
    $num_files = 0;
    @error_file_list = ();
    foreach my $service (@service2_list) {
	$today_file = "${service}/assoc_mid";
	$yesterday_file = $today_file;
	if (check_file($today_file, $yesterday_file) == 0) {
	    ++$num_files;
        } else {
            push @error_file_list, $today_file;
	}
    }
    if ($num_files == $num_service2_list) {
	$result .= "Ok\n";
    } else {
	$result .= "NOT Ok, $num_files, @error_file_list\n";
    }
    
    $result .= "====== checking final result files (service_YYMMDD) ======\n";
    $num_files = 0;
    @error_file_list = ();
    foreach my $service (@service1_list) {
	$today_file = "${service}/${service}_${date1_str}";
	$yesterday_file = "${service}/${service}_${date2_str}";
	if (check_file($today_file, $yesterday_file) == 0) {
	    ++$num_files;
        } else {
            push @error_file_list, $today_file;
	}
    }
    if ($num_files == $num_service1_list) {
	$result .= "Ok\n";
    } else {
	$result .= "NOT Ok, $num_files, @error_file_list\n";
    }

    $result .= "===================\n";
    $result .= "====== error ======\n";
    $result .= "===================\n";
    $result .= "====== zero size file ======\n";
    $result .= `find . -size 0`;
    $result .= "====== core file ======\n";
    $result .= `find . -name "core*" -exec file \"{}\" \\\;`;
    $result .= "====== debug info ======\n";
    #$result_str =~ s!$work_dir/!!g;
    $result .= $result_str;
    print `date`;

    if ($ARGV[0] eq "0") {
	print $result;
	exit(0);
    }

# notify me
    my $t;
    my $smtp_server = "smail01.nhncorp.com";
    my $sender_name = "Young-il Cho";
    my $receiver_name = "Young-il Cho";
    my $sender_addr = "terzeron\@nhncorp.com";
    my $receiver_addr = "terzeron\@nhncorp.com";
    my $subject = "Association generation report at $host_name";
    my $body = $result;
    my @output;

    $t = new Net::Telnet(Host => $smtp_server, Port => 25, Timeout => 10);
    print $t->getline;

    send_message($t, "HELO $smtp_server\n");
    print $t->getline;

    send_message($t, "MAIL FROM:<$sender_addr>\n");
    print $t->getline;

    send_message($t, "RCPT TO:<$receiver_addr>\n");
    print $t->getline;

    send_message($t, "DATA\n");
    print $t->getline;

    send_message($t, "From: $sender_name <$sender_addr>\n");

    send_message($t, "To: $receiver_name <$receiver_addr>\n");

    send_message($t, "Subject: $subject\n\n");

    send_message($t, "$body\n.\n");
    print $t->getline;

    send_message($t, "QUIT\n");
    print $t->getline;

    $t->close;
    print "sent mail to $receiver_addr\n";

    print "\n";
}

main();
exit(0);
