#!/usr/local/bin/perl
#############################
# 방명록 CGI(visit.cgi)
##############################

require 'cgi-lib.pl'; # 라이브러리 포함 (C에서의 #include와 동일)

# 현재의 시간을 변수 $date에 치환
#--------------------------------
$DATE='/usr/bin/date';
chop($date=`$DATE`);

# 환경변수 'REMOTE_HOST'를 변수 $access_log에 치환
#-------------------------------------------------
$access_log=$ENV{'REMOTE_HOST'};

# < form >으로 입력받은 변수를 각각의 변수로 치환
#----------------------------------------------
&ReadParse;
$name=$in{'name'};
$address=$in{'address'};
$content=$in{'content'};
$homepg=$in{'homepg'};

$org=$in{'org'};
if(($name eq '')||($address =~/[ ]+/)) 
# 변수 name과 address에 공백이 포함되어있을때
{
  &input_html;
# 전달되는 변수가 없을때 입력상태의 html문서를 보여주는 서버루틴의 호출
}
else{
  &update_data; # 방명록의 데이타파일을 갱신시키는 서브루틴의 호출
  &input_ok; # 입력이 완료되었음을 보여주는 서브루틴의 호출
}

#=======================================================================# 
#                             서 브 루 틴                               #
#=======================================================================#
#   방명데이터 파일 갱신  #
#=========================#
sub update_data
{
  $date_log=&date_proc; # 현재의 시간을 저장
  open(VISIT,">>data.html");
  print VISIT<<END
<font size=2>
o 작성일 : $date_log <br>
o 작성자 :<a href="http://$homepg"> $name </a> o 소 속 : $org <br>
o E-mail : <a href="mailto:$address"> $address </a> o 사용중인 호스트 : $access_log <br>
<pre>
$content
</pre></font>
<hr>
END
  close VISIT;
}

# 날짜 처리 #
#===========#

sub date_proc
{
  @date_item=split(/[ ]+/,$date);
  $month=$date_item[1];
  $day=$date_item[2];
  $time=$date_item[3];
  $year=$date_item[5];
  if($month =~ /Jan/) {$month = 1;}
  elsif($month =~ /Feb/) {$month = 2;}
  elsif($month =~ /Mar/) {$month = 3;}
  elsif($month =~ /Apr/) {$month = 4;}
  elsif($month =~ /May/) {$month = 5;}
  elsif($month =~ /Jun/) {$month = 6;}
  elsif($month =~ /Jul/) {$month = 7;}
  elsif($month =~ /Aug/) {$month = 8;}
  elsif($month =~ /Sep/) {$month = 9;}
  elsif($month =~ /Oct/) {$month = 10;}
  elsif($month =~ /Nov/) {$month = 11;}
  elsif($month =~ /Dec/) {$month = 12;}
  return "$year년 $month월 $day일 ($time)";
}

# 데이타 입력완료시의 중간결과출력 HTML문서 #
#===========================================#

sub input_ok
{
  print &PrintHeader;
  print<<EOF
<html>
<head><title>입력되었습니다.</title></head>
<body>
$name 님께서 아래와같이 작성하셨습니다. <p>
<dl>
<dd>o 소 속 : $org
<dd> o E-mail :<a href=\"mailto:$address\">$address</a>
<pre> $content </pre>
</dl>
<a href="visit.cgi\">열람 </a>하십시요.
</body>
</html>
EOF
  exit;
}

# 방명록 초기화면  #
#==================#

sub input_html
{
  $visit_data_html=&visit_data_proc;
  print &PrintHeader;
  print<<EOFOUT
<html>
<head>
<title>방명록</title>
</head>
<body>
<hr noshade><h2>방명록 </h2>
방명록 작성은 <a href="#write"> 아래 </a> 에서 하십시요. <br>
<hr noshade>
$visit_data_html
<a name="write">
<font size=2>
<font size=3>
<center> 귀하께서는 [ $access_log ] 를 통해 접속중이십니다. </center>
</font>
<form method="post" action="visit.cgi">
o 이름 : <input name="name" size=20> o Home-Page : http://<input name="homepg" size=25><br>
o 소속 : <input name="org" size=20><br>
o E-mail : <input name="address" size=30 value=" \@$access_log"><p>
o 작성란(HTML 사용가능) :<p>
<center>
<textarea cols=60 rows=6 name="content"></textarea><p>
<input type="submit" value="등록">
<input type="reset" value="재등록">
</center>
</form>
</font>
<hr>
</body>
</html>
EOFOUT
  exit;
}

#방명록 데이타파일을 읽어옴
#==========================#
sub visit_data_proc
{
  open(DATA, "data.html");
  @visit_data= < DATA >;
  close(DATA);
  return "@visit_data";
}
