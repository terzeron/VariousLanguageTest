#!/usr/local/bin/perl
#############################
# ���� CGI(visit.cgi)
##############################

require 'cgi-lib.pl'; # ���̺귯�� ���� (C������ #include�� ����)

# ������ �ð��� ���� $date�� ġȯ
#--------------------------------
$DATE='/usr/bin/date';
chop($date=`$DATE`);

# ȯ�溯�� 'REMOTE_HOST'�� ���� $access_log�� ġȯ
#-------------------------------------------------
$access_log=$ENV{'REMOTE_HOST'};

# < form >���� �Է¹��� ������ ������ ������ ġȯ
#----------------------------------------------
&ReadParse;
$name=$in{'name'};
$address=$in{'address'};
$content=$in{'content'};
$homepg=$in{'homepg'};

$org=$in{'org'};
if(($name eq '')||($address =~/[ ]+/)) 
# ���� name�� address�� ������ ���ԵǾ�������
{
  &input_html;
# ���޵Ǵ� ������ ������ �Է»����� html������ �����ִ� ������ƾ�� ȣ��
}
else{
  &update_data; # ������ ����Ÿ������ ���Ž�Ű�� �����ƾ�� ȣ��
  &input_ok; # �Է��� �Ϸ�Ǿ����� �����ִ� �����ƾ�� ȣ��
}

#=======================================================================# 
#                             �� �� �� ƾ                               #
#=======================================================================#
#   ������� ���� ����  #
#=========================#
sub update_data
{
  $date_log=&date_proc; # ������ �ð��� ����
  open(VISIT,">>data.html");
  print VISIT<<END
<font size=2>
o �ۼ��� : $date_log <br>
o �ۼ��� :<a href="http://$homepg"> $name </a> o �� �� : $org <br>
o E-mail : <a href="mailto:$address"> $address </a> o ������� ȣ��Ʈ : $access_log <br>
<pre>
$content
</pre></font>
<hr>
END
  close VISIT;
}

# ��¥ ó�� #
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
  return "$year�� $month�� $day�� ($time)";
}

# ����Ÿ �Է¿Ϸ���� �߰������� HTML���� #
#===========================================#

sub input_ok
{
  print &PrintHeader;
  print<<EOF
<html>
<head><title>�ԷµǾ����ϴ�.</title></head>
<body>
$name �Բ��� �Ʒ��Ͱ��� �ۼ��ϼ̽��ϴ�. <p>
<dl>
<dd>o �� �� : $org
<dd> o E-mail :<a href=\"mailto:$address\">$address</a>
<pre> $content </pre>
</dl>
<a href="visit.cgi\">���� </a>�Ͻʽÿ�.
</body>
</html>
EOF
  exit;
}

# ���� �ʱ�ȭ��  #
#==================#

sub input_html
{
  $visit_data_html=&visit_data_proc;
  print &PrintHeader;
  print<<EOFOUT
<html>
<head>
<title>����</title>
</head>
<body>
<hr noshade><h2>���� </h2>
���� �ۼ��� <a href="#write"> �Ʒ� </a> ���� �Ͻʽÿ�. <br>
<hr noshade>
$visit_data_html
<a name="write">
<font size=2>
<font size=3>
<center> ���ϲ����� [ $access_log ] �� ���� �������̽ʴϴ�. </center>
</font>
<form method="post" action="visit.cgi">
o �̸� : <input name="name" size=20> o Home-Page : http://<input name="homepg" size=25><br>
o �Ҽ� : <input name="org" size=20><br>
o E-mail : <input name="address" size=30 value=" \@$access_log"><p>
o �ۼ���(HTML ��밡��) :<p>
<center>
<textarea cols=60 rows=6 name="content"></textarea><p>
<input type="submit" value="���">
<input type="reset" value="����">
</center>
</form>
</font>
<hr>
</body>
</html>
EOFOUT
  exit;
}

#���� ����Ÿ������ �о��
#==========================#
sub visit_data_proc
{
  open(DATA, "data.html");
  @visit_data= < DATA >;
  close(DATA);
  return "@visit_data";
}
