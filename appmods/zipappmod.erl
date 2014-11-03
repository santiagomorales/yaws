-module(zipappmod).
-author('santi').

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

box(Str) ->
	{'div', [{class, "box"}],
		{pre, [], Str}}.

prueba() ->
	receive
		A ->
			io:format("Received:~p~n", [A#arg.appmoddata])
	end,
	prueba().


out(A) ->
	prueba ! A,
	{ehtml,
		[{p, [],
			box(io_lib:format("A#arg.appmoddata = ~p~n",
						 	  [A#arg.appmoddata]))
	  }]}.



start() ->
	register(prueba, spawn(zipappmod, prueba, [])).
