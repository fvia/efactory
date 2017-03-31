-module(factory).
-behavior(gen_server).

-export([start/1,stop/0]).
-export([init/1,terminate/2,handle_call/3,handle_cast/2,handle_info/2,code_change/3]).

% tick: simulation advances one step 
-export([tick/0,test_call/0]).




start(Env) -> 
	% 
	gen_server:start_link({global,?MODULE},?MODULE,Env,[]).
	%gen_server:start({local,?MODULE},?MODULE,Env,[]).

stop() ->
	gen_server:cast({global,?MODULE},stop).


init(Env) -> 
	io:format("Factory starting~n"),
	extruder:start({e1,20,0,20,100}),
    extruder:start({e2,20,0,25,100}),
    gen_event:start_link({global, gossip_manager}),
    gen_event:add_handler( {global,gossip_manager}, gossip, []),
	{ok,Env}.

terminate(Reason,Env) ->
	extruder:stop(e1),
	extruder:stop(e2),
	io:format("Factory terminate, Reason: ~p  Env: ~p ~n",[Reason,Env]),
	ok.



handle_call(test_call,_From,LoopData) ->
	_ = 10/0,
	Reply = "okDoky",
	{reply,Reply,LoopData};  
handle_call(Message,From,LoopData) ->
	io:format("Factory handle_call, Msg: ~p  From: ~p  Data: ~p ~n",[Message,From,LoopData]),
	Reply = "ja vorem",
	{reply,Reply,LoopData}.   


handle_cast(stop,Env) ->
	io:format("Factory handle_cast stop ,  Env: ~p   ~n",[Env]),
	{stop,normal,Env};   
handle_cast(tick,State) ->
	extruder:tick(e1),
	extruder:tick(e2),
	io:format("Factory tick, State: ~p   ~n",[State]),
	{noreply,State};  
handle_cast(Request,State) ->
	io:format("Factory handle_cast, Request: ~p  State: ~p   ~n",[Request,State]),
	{noreply,"No se"}.   


% This function is called by a gen_server process when a time-out occurs or 
%  when it receives any other message than a synchronous or asynchronous request (or a system message).
handle_info(Info, State) ->
	io:format("Factory handle_info ,  Info: ~p   ~n",[Info]), 
	Reason = unexpected,
	NewState = State,
	{stop,Reason,NewState}.

% Just to don't see the warning
code_change(_OldVsn, State, _Extra) ->
	io:format("Factory  code_change:    ~n"), 
	{ok, State}.


tick() -> 
	gen_server:cast({global,?MODULE},tick),
	ok.	

test_call() -> 
	gen_server:call({global,?MODULE},test_call).		