#!/usr/bin/env perl

#use strict;
use English;
use Time::localtime;
use Expect;
$Expect::Log_Stdout = 0; # Do NOT print log content to standard output

sub main
{
    my $cmd;
    my $exp;
    my $timeout = 2;

    # prepare
    $cmd = "ssh -l kids kids.kornet.net";
    $exp = Expect->spawn($cmd) or goto main_error;

    $exp->expect($timeout, '����ڸ�(User  Id): ');
    $exp->send("guest\r");
    $exp->expect($timeout, 'I Am ');
    $exp->send("guest\r\r\r");
    $exp->expect($timeout, '������');
    $exp->send("\r");
    $exp->expect($timeout, 'Kids ����');
    $exp->send("s\r");
    $exp->expect($timeout, 'H: ����');
    $exp->send("u\r");

    while (1) {
	$exp->expect($timeout, 
			 [ timeout, sub { $exp->send("\n"); } ],
		     [ '-re', 
		       '\d+\s(\w+)\s+(\S+)\s+\d+\s\S+\s+(Kr|eN)(\s+(\w+))?',
		       sub {
			   @matched = $exp->matchlist();
			   $id = $matched[0];
			   $nickname = $matched[1];
			   $status = $matched[4];
			   chomp $id, $nickname, $status;
			   
			   $t = ctime();
			   if ($id ne "guest" and $id ne "shanx" and $status eq "Editing") {
			       print STDERR $t . ": $id $nickname $status\n";
			   } 
		       } ], 
		     [ '-re',
		       '\x1b\x5b\x6d\x0f\x1b\x5b', 
		       sub { $exp->send("\n"); } ],
		     #[ '-re',
		     #  '\x1b\x5b\x33\x43', 
		     #  sub { $exp->send("\n"); } ],
		     [ '-re',
		       '\x30\x3b\x31\x3b\x37',
		       sub { $exp->send("u\n"); } ],	
		     [ '-re',
		       'ġ�ʽÿ�.',
		       sub { $exp->send("\n"); sleep $timeout; } ],	
	     );
    }


    # finalize
    $exp->soft_close();
    $exp->hard_close();
    exit(0);
    
  main_error:
    $exp->soft_close();
    $exp->hard_close();
    exit(-1);
}


main();


