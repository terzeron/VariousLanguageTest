c(echo).

Pid = echo:start().
Pid ! { self(), 12345 }.
receive Value -> Value end.

halt().