all: bag.beam  coil.beam extruder.beam factory.beam gossip.beam  

bag.beam: bag.erl
	erlc bag.erl	

coil.beam:
	erlc coil.erl

extruder.beam:
	erlc extruder.erl

factory.beam:
	erlc factory.erl

gossip.beam:
	erlc gossip.erl
