#!/bin/tcsh

script list 
./kidsusers1
exit
./idlist.pl list | sort -u >! userlist1
script list 
./kidsusers2
exit
perl -ne 'if (/\d{1,5}\s+([^\x1b^\s]+)/) { print "$1\n"; } ' \
	list | sort -u >! userlist2
cat userlist? | sort -u >! userlist

# ����� �˻�
perl -ne "print if /[\000-\011\013-\037\177-\377]/" userlist | \
perl -pe 's/\n$/  /g'|less

/bin/rm -f kidsadmin
cp -f script_head kidsadmin
foreach f (`cat userlist except_userlist`)
	echo '    expect -re "H :����" { send "w\r" }' >> kidsadmin
	echo '    expect -re "UserID  : " { send "'$f'\r" }' >> kidsadmin
	echo '    expect -re "ġ�ʽÿ�." { send "\r" }' >> kidsadmin
end
cat script_tail >> kidsadmin
chmod a+x kidsadmin
script userinfo 
./kidsadmin
exit

./parseinfo.pl userinfo | sort -rn -k1 | ./order.pl 1 > posting
./parseinfo.pl userinfo | sort -rn -k2 | ./order.pl 2 > login
echo -n "              ������ ��" >! total_statistics
echo "                               �α��� ��" >> total_statistics
echo -n " ����  ���̵� ������ �α��� ����" >> total_statistics
echo  "         ����   ���̵� ������ �α��� ����" >> total_statistics
paste posting login >> total_statistics

