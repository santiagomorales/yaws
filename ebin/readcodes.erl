-module(readcodes).
-compile(export_all).
-author('santi').

procesar(Origen) ->
	case file:open(Origen, read) of
		{ok, Fd_origen} ->
			procesar_linea(Fd_origen),
			file:close(Fd_origen),
			{ok};
		{error, Motivo} ->
			{error, Motivo}
	end.

procesar_linea(Fd_origen) ->
	case io:get_line(Fd_origen, '') of
		eof ->
			io:format("Done ~n");
		{error, Motivo} ->
			{error, Motivo};
		Linea ->
			Tokens = string:tokens(Linea, "\n"),
			io:format("~s~n", [Tokens]),
			procesar_linea(Fd_origen)
	end.
