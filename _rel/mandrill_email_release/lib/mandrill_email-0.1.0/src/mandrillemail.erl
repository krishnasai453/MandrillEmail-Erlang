-module(mandrillemail).
-export([send_email/6]).


%%===========================================================================
%% Defining Macros
%% @doc
%% make sure to start this function when using this module for starting various services
%%end

-define(SECRET_KEY,"Dy93viVphIw7h-mM5wWaow").
-define(FROM_EMAIL,"krishnasai453@gmail.com").
-define(FROM_NAME,"Krishna Sai").
-define(TEXT,"What ever you want to enter ").
-define(REPLY_EMAIL,"krishnasai453@gmail.com").
-define(HTML,"<p>Keep Sqoring</p>").
-define(Company,"SQOR Inc").

%%===========================================================================
%% function: start/0
%% @doc
%% make sure to start this function when using this module for starting various services
%%end

%start()->
%    ok = application:start(crypto),
%    ok = application:start(asn1),
%    ok = application:start(public_key),
%    ok = application:start(ssl),
%    ok = application:start(jsx),
%    ok = application:start(inets).

%%===========================================================================
%% function: send_email/0
%% @doc
%% sending email by converting the input strings to binary and parse to json
%% to hit mandrill api 
%%end

send_email( RecipientEmail,RecipientName,Subject,Template,Merge_key,Merge_value)-> 
    RecipientDetails={<<"to">>,[get_bin([{"email",RecipientEmail},
        {"name",RecipientName},{"type","to"}],[])]},
    Headers ={<<"headers">>,[to_bin({"Reply-To",?REPLY_EMAIL})]},
    TemplateContent = {<<"template_content">>,[get_bin([{"name","Recipient_Name"},{"content",RecipientName}],[])]},
    GlobalMergeVars = {<<"global_merge_vars">>,[get_bin([{"name",Merge_key},{"content",Merge_value}],[])]},
    Message = {<<"message">>,[RecipientDetails,
                Headers,
                GlobalMergeVars|
                get_bin([%{"html",?HTML},
                {"text",?TEXT},
                {"subject",Subject},
                {"from_email",?FROM_EMAIL},
                {"from_name",?FROM_NAME},
                {"track_opens",false},
                {"track_clicks",false},
                {"tracking_domain",false}],[])
                ]}, 
    PostParams = [Message,TemplateContent|get_bin([{"key",?SECRET_KEY},
    				{"template_name",Template},
           			% {"send_at",get_time()},
           			{"async","false"},
            		{"ip_pool","Main Pool"}],[])],
    Jsondata = jsx:encode(PostParams),
    send_request(Jsondata).
    
    
%%===========================================================================
%%  function: get_bin/2,to_bin/1
%%	@doc
%%	Converting input strings to binary for JSX as JSX takes
%%  only atoms or binary
%%	end   

get_bin([],ResultBinPropList) ->
    lists:reverse(ResultBinPropList);
get_bin([{Key,Value}|Tail],Result) ->
    get_bin(Tail,[to_bin({Key,Value})]++Result).    
to_list(Data) when is_list(Data) ->
    Data;
to_list(Data) when is_atom(Data) ->
    atom_to_list(Data);
to_list(Data) when is_integer(Data) ->
    integer_to_list(Data);
to_list(Data) when is_binary(Data) ->
    binary_to_list(Data).
to_bin({A,B})  ->
    {to_bin(A),to_bin(B)};
to_bin({A,B,C}) ->
    {to_bin(A),to_bin(B),to_bin(C)};
to_bin(A) when is_list(A) ->
    list_to_binary(A);
to_bin(A) when is_integer(A) ->
    integer_to_binary(A);
to_bin(A) when is_atom(A) ->
    list_to_binary(to_list(A));
to_bin(A) when is_binary(A) ->
    A.    

%%===========================================================================
%% function: send_request/1
%%	@doc
%%	Erlang http:request that posts with a json payload
%%	end

send_request(Jsondata)->
	Method = post,
	URL =  "https://mandrillapp.com/api/1.0/messages/send-template.json",
	Header = [],
	Body = Jsondata,
    Type = "application/json",
	Options = [],
	httpc:request(Method, {URL, Header, Type, Body}, [], Options).
