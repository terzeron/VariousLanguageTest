#!/bin/tcsh

../parseinfo.pl userinfo.new > result.new
../parseinfo.pl userinfo.old > result.old
./diff.pl | sort -rn -k2 | ./order.pl 1 > posting
./diff.pl | sort -rn -k3 | ./order.pl 2 > login
(echo "             ������ ��                              �α��� ��"; echo "����  ���̵� ������ �α��� ����         ����   ���̵� ������ �α��� ����") > difflist 
paste posting login >> difflist
#\rm posting login

cat exception_list

