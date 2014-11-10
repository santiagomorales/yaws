-module(zipappmod).
-author('santi').

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

-record(address, {postalcode, placename, state, county, stateab, latitude, longitude}).

box(Str) ->
	{'div', [{class, "box"}],
		{pre, [], Str}}.

prueba() ->
	receive
		{A, Web_pid} ->
			io:format("Received:~p~n", [A#arg.appmoddata]),
			Mensaje = "El servidor dice que OK",
			Web_pid ! {Mensaje, A#arg.appmoddata}
	end,
	prueba().


out(A) ->
	prueba ! {A, self()},
	receive
		{Mensaje, Pid} ->
			{ehtml,
				[{p, [],
					box(io_lib:format("~p~nA#arg.appmoddata = ~p~n",
						 	  [Mensaje, Pid]))
	 		 }]}
	end.

procesar() ->
		receive
			{Origen} ->
				case file:open(Origen, read) of
					{ok, Fd_origen} ->
						procesar_linea(Fd_origen),
						file:close(Fd_origen),
						{ok};
					{error, Motivo} ->
						{error, Motivo}
				end
		end.

procesar_linea(Fd_origen) ->
		case io:get_line(Fd_origen, '') of
			eof ->
				io:format("Done ~n");
			{error, Motivo} ->
				{error, Motivo};
			Linea ->
				[Postal, Place, State, StateAb, County, Latitude, Longitude, Rest] = string:tokens(Linea, ","),
				ets:insert(tablaETS, #address{postalcode = Postal, placename = Place, state = State, stateab = StateAb, 
						county = County, latitude = Latitude, longitude = Longitude}),
				procesar_linea(Fd_origen)
		end.

start() ->
	register(procesar, spawn(zipappmod, procesar, [])),
	register(prueba, spawn(zipappmod, prueba, [])),
	procesar ! {""}.
