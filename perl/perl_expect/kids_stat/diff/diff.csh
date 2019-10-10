#!/bin/tcsh

../parseinfo.pl userinfo.new > result.new
../parseinfo.pl userinfo.old > result.old
./diff.pl | sort -rn -k2 | ./order.pl 1 > posting
./diff.pl | sort -rn -k3 | ./order.pl 2 > login
(echo "             포스팅 순                              로그인 순"; echo "순위  아이디 포스팅 로그인 비율         순위   아이디 포스팅 로그인 비율") > difflist 
paste posting login >> difflist
#\rm posting login

cat exception_list

