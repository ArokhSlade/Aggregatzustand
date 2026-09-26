extends Node2D

@export var player_scene : PackedScene

@export var level_start : Node2D

var current_state : State
var player

var states = {
	"paused" : Paused.new(self),
	"playing" : Playing.new(self)
}


func _ready():
	current_state = states.paused
	if level_start:
		level_start.initialize(player_scene)
		level_start.spawn()


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


func _on_level_start_player_spawned(player_):
	add_child(player_)
	player = player_
