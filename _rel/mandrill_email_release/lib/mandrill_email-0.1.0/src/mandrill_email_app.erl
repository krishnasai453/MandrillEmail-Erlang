-module(mandrill_email_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).
-export([debug/0]).

debug() ->
    _ = application:start(crypto),
    _ = application:start(asn1),
    _ = application:start(public_key),
    _ = application:start(ssl),
    _ = application:start(jsx),
    _ = application:start(inets).

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", email_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_http(http, 100, [{port, 8080}], [
		{env, [{dispatch, Dispatch}]}
	]),
	mandrill_email_sup:start_link().

stop(_State) ->
	ok.
