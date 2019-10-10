-module(echo).
-export([start/0]).

loop() -> receive
  { Sender, Num } ->
    Sender ! [Num * 2],
    loop()
  end.

start() -> spawn(fun loop/0).