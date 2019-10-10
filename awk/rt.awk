BEGIN {
  rank = 0;
  occur = 0;
  ts = substr(ARGV[1], 12, 14);
  keyword = "이명박 미니홈피";
} 

{
  if ($2 == 0) {
    rank = rank + 1;
  } 
  if ($1 == keyword) { 
    print ts "\t" rank "\t" $6 "\t" $9;
    occur=1
  }
} 

END {
  if (occur == 0) {
    rank = 50;
    uipcnt = 0;
    abuse_rate = 1.0;
    print ts "\t" rank "\t" uipcnt "\t" abuse_rate;
  }
}
