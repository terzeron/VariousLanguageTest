#!/usr/local/bin/perl

$CLIENT = "/usr/local/bin/ztelnet";
$OPTIONS = "-8";
$IPADDR = "203.238.128.51";
$LOGIN_ID = "terzeron";
$PASSWD = "micro575";
$INDEXFILE = "mirror_index";
$time_ratio = 1;

sub read_menu {
  if (-f $INDEXFILE) {
    open(INDEX, $INDEXFILE);
    $i = 0;
    while (<INDEX>) {
      if ( /^\s*(\w.+\w)\s*=\s*(\d+)\s*$/ ) {  # ex. ssci 1 5 1 = 392
        $menu[$i] = $1;
        $i ++;
        print $i + $menu[$i-1];
      }
    }
    close(INDEX);
  }
}

if ($child_pid = fork()) {
  open(NETWORK, "|$CLIENT $OPTIONS $IPADDR 2>&1");
  print NETWORK "telsktjsl
";
  sleep 5/$time_ratio;
  print NETWORK "
";
  sleep 5/$time_ratio;
  print NETWORK "$LOGIN_ID
";
  sleep 2/$time_ratio;
  print NETWORK "$PASSWD
";
  sleep 8/$time_ratio;
  print NETWORK "
";
  sleep 2/$time_ratio;
  read_menu();
  for ($i = 0; $i <= $#menu; $i ++) {
    print NETWORK "go $menu[$i]\n";
    sleep 15/$time_ratio;
    print NETWORK "Logo page pass...\n";
    sleep 10/$time_ratio;
  }
  print NETWORK "bye\n";
  sleep 10/$time_ratio;
  print NETWORK "x\ny\n";
  sleep 10/$time_ratio;
  #kill 'KILL', $child_pid;
}
  

