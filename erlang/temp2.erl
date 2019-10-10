-module(temp2).
-export([start/0]).
tempConverter() ->  
  receive 
   {From, {toF, C}} -> From ! {self(), [32+C*9/5]}, tempConverter();    
   {From, {toC, F}} -> From ! {self(), [(F-32)*5/9]}, tempConverter();    
   {stop} -> io:format("stopping~n")
end.
start() -> spawn(fun() -> tempConverter() end).
