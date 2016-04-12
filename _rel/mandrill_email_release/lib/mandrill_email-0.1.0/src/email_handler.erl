-module(email_handler).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).


init(_Transport, Req, []) ->
	
	{ok, Req, undefined}.

handle(Req, State) ->
	{Method, Req2} = cowboy_req:method(Req),
	HasBody = cowboy_req:has_body(Req2),
	{ok, Req3} = maybe_echo(Method, HasBody, Req2),
	{ok, Req3, State}.

maybe_echo(<<"POST">>, true, Req) ->
	{ok, PostVals, Req2} = cowboy_req:body_qs(Req),
	EmailInput = proplists:get_value(<<"remail">>, PostVals),
	PostValsBin = binary:bin_to_list(EmailInput),
	InputString = string:tokens(PostValsBin,","),
	[RecipientEmail,RecipientName,Subject,Template,Merge_key,Merge_value] = InputString,
	case mandrillemail:send_email(RecipientEmail,RecipientName,Subject,Template,Merge_key,Merge_value) of
		{ok, {{"HTTP/1.1",200, State}, _Head, ResponseBody}} ->
	       io:format("HTTP/1.1,200,State :~p~n~n Body : ~p ~n~n",[State, ResponseBody]),
	       cowboy_req:reply(200, [
		{<<"content-type">>, <<"application/json">>}
	], ResponseBody, Req2);
	   {ok, {{"HTTP/1.1",ResponseCode, _State}, _Head, ResponseBody}} ->
	        io:format("Response code : ~p~n Body :~p~n~n",[ResponseCode, ResponseBody]),
	       cowboy_req:reply(400, [], <<"Failed to sent the mail!">>, Req2);
	   {error,Reason} ->
	       io:format("~nerror error : ~p~n",[Reason]),
	       	cowboy_req:reply(400, [], <<"Missing echo parameter.">>, Req2)
	end;
maybe_echo(<<"POST">>, false, Req) ->
	cowboy_req:reply(400, [], <<"Missing body.">>, Req);
maybe_echo(_, _, Req) ->
	%% Method not allowed.
	cowboy_req:reply(405, Req).

terminate(_Reason, _Req, _State) ->
	ok.




