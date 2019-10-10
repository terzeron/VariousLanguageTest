#!/usr/bin/env perl

use strict;
use warnings;
use English;
use POSIX qw(mktime);
use POSIX qw(strftime);

sub main
{
    my ($dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size, $atime, $mtime, $ctime, $blksize, $blocks) = stat $ARGV[0];
    print strftime("%y%m%d", localtime($mtime - 60 * 60 * 24));
}

main();
