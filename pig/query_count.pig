A = load '/user/hadoop/terzeron/mezzo2.log' using MezzoLoader();
B = foreach A generate flatten($1), '1'  as count;
C = group B by $0#'qy';
D = foreach C generate $0 as query, SUM(B.count) as count;
DUMP D;
