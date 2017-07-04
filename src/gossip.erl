-module(gossip).
-behavior(gen_event).
-export([init/1,terminate/2,handle_event/2,handle_call/2,handle_info/2,code_change/3]).




init(_InitArgs) -> 
	{ok,[]}.

terminate(_Reason,_Env) ->
	ok.

handle_event(Event, State) ->
	io:format("gossip handle_event .: ~p   ~n",[Event]),
	{ok,State}.

% This function is called by a gen_server process when a time-out occurs or 
%  when it receives any other message than a synchronous or asynchronous request (or a system message).
handle_info(Info, State) ->
	io:format("gossip handle_info ,  Info: ~p   ~n",[Info]), 
	Reason = unexpected,
	NewState = State,
	{stop,Reason,NewState}.

handle_call(Request,State) ->
	io:format("gossip handle_call, Msg: ~p   Data: ~p ~n",[Request,State]),
	Reply = "ja vorem",
	{reply,Reply,State}.   



% Just to don't see the warning
code_change(_OldVsn, State, _Extra) ->
	io:format("gossip  code_change:    ~n"), 
	{ok, State}.


