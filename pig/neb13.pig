logs = LOAD 'tsv_cr.log';
filtered = FILTER logs BY $12 eq 'rkl.list';
converted = FOREACH filtered GENERATE FIRSTTOKEN($2) AS date, $13 AS rank, $5 AS query;
grouped = GROUP converted BY (date, rank);
result = FOREACH grouped GENERATE group.date, group.rank, COUNT(converted.query) AS cnt;
sorted = ORDER result BY (date, rank);
DUMP sorted;
