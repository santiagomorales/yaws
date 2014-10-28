-module(zipappmod).
-author('santi').

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

box(Str) ->
	{ 'div', [{class, "box"}],
		{pre, [], Str}}.

out(A) ->
	{ehtml,
		[{p, [],
		  box(io:format("A#arg.appmoddata = ~p~n", [A#arg.appmoddata]))}]}.

