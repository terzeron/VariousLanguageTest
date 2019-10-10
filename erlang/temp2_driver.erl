c(temp2).
Pid = temp2:start().
Pid ! {self(), {toF, 100}}.
receive  {Pid2, Value} -> io:format(“return value: ~p~n”, Value)  end.
halt().
