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

# 제어문자 검사
perl -ne "print if /[\000-\011\013-\037\177-\377]/" userlist | \
perl -pe 's/\n$/  /g'|less

/bin/rm -f kidsadmin
cp -f script_head kidsadmin
foreach f (`cat userlist except_userlist`)
	echo '    expect -re "H :도움" { send "w\r" }' >> kidsadmin
	echo '    expect -re "UserID  : " { send "'$f'\r" }' >> kidsadmin
	echo '    expect -re "치십시오." { send "\r" }' >> kidsadmin
end
cat script_tail >> kidsadmin
chmod a+x kidsadmin
script userinfo 
./kidsadmin
exit

./parseinfo.pl userinfo | sort -rn -k1 | ./order.pl 1 > posting
./parseinfo.pl userinfo | sort -rn -k2 | ./order.pl 2 > login
echo -n "              포스팅 순" >! total_statistics
echo "                               로그인 순" >> total_statistics
echo -n " 순위  아이디 포스팅 로그인 비율" >> total_statistics
echo  "         순위   아이디 포스팅 로그인 비율" >> total_statistics
paste posting login >> total_statistics

