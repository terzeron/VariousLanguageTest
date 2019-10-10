a = load 'test.tsv';
dump a;
b = group a by ($0, $1);
dump b;
