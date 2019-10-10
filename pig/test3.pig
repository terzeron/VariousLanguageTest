user_sequences = LOAD 'mezzo.log' USING MezzoLoader();
out = GROUP user_sequences BY $0.$1;
DUMP out;
