extends Node2D

var current_state : State

var states = {
	"paused" : Paused.new(self),
	"playing" : Playing.new(self)
}


func _ready():
	current_state = states.paused


func pause():
	process_mode = Node.PROCESS_MODE_DISABLED
	switch_state_to(states.paused)


func unpause():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	switch_state_to(states.playing)


func switch_state_to(new_state):
	current_state = new_state


@abstract class State:
	var owner 
	
	@abstract func on_process()
	
	func _init(owner_):
		owner = owner_


class Playing extends State:
	
	func on_process():
		pass


class  Paused extends State:
	
	func on_process():
		return
