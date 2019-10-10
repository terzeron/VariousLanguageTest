qc = LOAD 'test.txt' AS (keyword, cnt);
grps = GROUP qc BY keyword;
grpcnt = FOREACH grps GENERATE qc.keyword, SUM(qc.cnt) as sum;
DUMP grpcnt;

