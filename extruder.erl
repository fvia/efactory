-module(extruder).
-behavior(gen_server).

-export([start/1,stop/1]).
-export([init/1,terminate/2,handle_call/3,handle_cast/2,handle_info/2,code_change/3]).

-export([test_call/1,tick/1]).

-include("factory.hrl").


%%%%%%%%%%%%%%% ENV %%%%%%%%%%%%%%%%%%%%
%%  {extruderName,Temperature,Speed,TargetTemperature,TargetSpeed}

start(Env) -> 
	#extruderSt{name=Name}=Env,
	gen_server:start_link({global,Name},?MODULE,Env,[]).

stop(Name) ->
	gen_server:cast({global,Name},stop).


init(Env) -> 
	#extruderSt{name=Name}=Env,	
	io:format("Extruder ~p starting~n",[Name]),	
	{ok,Env}.

terminate(Reason,Env) ->
	io:format("Extruder terminate, Reason: ~p  Env: ~p ~n",[Reason,Env]),
	ok.


handle_call(test_call,_From,LoopData) ->
	#extruderSt{name=Name}= LoopData,
	io:format("Extruder ~p test_call ~n",[Name]),
	{reply,ok,LoopData};   
handle_call(Message,From,LoopData) ->
	io:format("Extruder handle_call, Msg: ~p  From: ~p  Data: ~p ~n",[Message,From,LoopData]),
	Reply = "ja vorem",
	{reply,Reply,LoopData}.   


handle_cast(tick,Env) ->
	#extruderSt{temperature=T0,targetTemperature=TT}= Env,
	T1 = if 
		T0 < TT  -> T0+1;
		true -> T0 
	end,
	NewEnv = Env#extruderSt{temperature=T1}, 

	io:format("Extruder tick 0,  Env: ~p   ~n",[NewEnv]),
	gen_event:notify({global,gossip_manager},{extruder,NewEnv}),
	{noreply,NewEnv};
handle_cast(stop,Env) ->
	io:format("Extruder handle_cast stop ,  Env: ~p   ~n",[Env]),
	{stop,normal,Env};   
handle_cast(test_call,State) ->
	io:format("Extruder , State: ~p   ~n",[State]),
	{noreply,State};  
handle_cast(Request,State) ->
	io:format("Extruder handle_cast, Request: ~p  State: ~p   ~n",[Request,State]),
	{noreply, State}.   


% This function is called by a gen_server process when a time-out occurs or 
%  when it receives any other message than a synchronous or asynchronous request (or a system message).
handle_info(Info, State) ->
	io:format("Extruder handle_info ,  Info: ~p   ~n",[Info]), 
	Reason = unexpected,
	NewState = State,
	{stop,Reason,NewState}.

% Just to don't see the warning
code_change(_OldVsn, State, _Extra) ->
	io:format("Extruder  code_change:    ~n"), 
	{ok, State}.


test_call(Name) ->
	gen_server:call( {global,Name}, test_call).

tick(Name) -> 
	gen_server:cast( {global,Name},tick),
	ok.	
