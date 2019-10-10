#!/usr/bin/perl -I/home1/terzeron/lib

use Expect;
use strict;
use English;

my $exp;
my $command;
my @params;
my @match_pattern;
my $timeout = 3;
my $common_id = "terzeron";
my $userid = "";
my $passwd = "password.";
my $prompt_str = '$ ';
my $host = $ARGV[0];
my $result;


sub print_usage() {
    print "\n";
    print "Usage: $PROGRAM_NAME <host>\n";
    print "\n";
}


sub main() {
    if (scalar @ARGV != 1) {
	print_usage();
	exit(-1);
    }
    
    # rsyncd_ip_list.sh을 원격 호스트로 복사
    $result = `rcp rsyncd_ip_list.sh $common_id\@$host:~/`;

    # Kerberos password가 expire되었을 것을 가정하여 kinit 실행
    $result = `echo $passwd | kinit $userid`;

    #
    # 원격 작업
    #

    # rsh로 연결
    $command = "rsh $host -l $common_id";
    $exp = new Expect;
    $exp->raw_pty(1);
    $exp->spawn($command) or die "can't spawn $command: $ERRNO\n";
    $exp->expect($timeout,
		 [ $prompt_str, sub { exp_continue; } ] 
		 );

    # 공통 계정 권한으로 할 일
    # 1) 디렉토리 생성
    # 2) 스크립트 복사 및 실행 권한 설정
    $exp->send("mkdir -f ~/$userid\n");
    $exp->send("/bin/mv -f ~/rsyncd_ip_list.sh ~/$userid\n");
    $exp->send("chmod a+x ~/$userid/rsyncd_ip_list.sh\n");

    # root 권한으로 할 일
    $exp->send("kinit $userid\n");
    $exp->expect($timeout,
		 [ "Password for $userid\@NAVER.COM:", 
		   sub { 
		       my $self = shift; 
		       $self->send("$passwd\r\n"); } ],
		 [ $prompt_str, 
		   sub { 
		       my $self = shift; 
		       $self->send("$passwd\n"); 
		       exp_continue; } ]
		 );
    $exp->send("ksu\n");
    $exp->expect($timeout, 
		 [ "account root: authorization failed", 
		   sub { } ],
		 [ "Changing uid to root", 
		   sub { 
		       # rsyncd_ip_list.sh 파일을 cron job으로 추가
		       $exp->send("grep rsyncd_ip_list.sh /var/spool/cron/root || echo '59 5,11 * * * /home1/$common_id/$userid/rsyncd_ip_list.sh' >> /var/spool/cron/root\n"); } ],
		 [ $prompt_str, sub { exp_continue; } ]
		 );
    
    # /etc/rsyncd.conf의 복사본을 홈에 생성
    $exp->send("/bin/cp -f /etc/rsyncd.conf ~$common_id/$userid/rsyncd.conf\n");
    $exp->send("chown $common_id ~$common_id/$userid/rsyncd.conf\n");
    
    # 원격 연결 종료
    $exp->send("exit\n");
    $exp->soft_close();
    $exp->hard_close();
    sleep(1);
    
    # 원격 호스트의 rsyncd.conf를 로컬 호스트로 복사해옴
    $result = `rcp $common_id\@$host:~/$userid/rsyncd.conf rsyncd.conf.$host`;
    exit(0);
}

main();

 main_error:
    print "error: $ERRNO\n";
exit(-1);




