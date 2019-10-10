c(temp1).
Pid = spawn(fun temp1:temperatureConverter/0).
Pid ! {toC, 32}.
Pid ! {toF, 100}.
Pid ! {stop}.

halt().