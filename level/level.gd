extends Node2D

signal level_finished

@export var player_scene : PackedScene
@export var level_start : Node2D

@export var DEBUG_aggregate_state_profile : AggregateStateProfile

## external dependency that must be initialize()'d
var aggregate_state_profile : AggregateStateProfile

var current_state : State
var player
var initialized = false

var states = {
	"paused" : Paused.new(self),
	"playing" : Playing.new(self)
}

func _ready():
	current_state = states.paused
	
	if not initialized:
		DEBUG_fallback_initialize()
	

func initialize(aggregate_state_profile_):
	aggregate_state_profile = aggregate_state_profile_
	
	if level_start:
		level_start.initialize(player_scene, aggregate_state_profile)
		level_start.spawn()
	
	initialized = true


func pause():
	process_mode = Node.PROCESS_MODE_DISABLED
	switch_state_to(states.paused)


func unpause():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	switch_state_to(states.playing)


func switch_state_to(new_state):
	current_state = new_state


func DEBUG_fallback_initialize():
	initialize(DEBUG_aggregate_state_profile)


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


func _on_level_goal_level_goal_reached():
	level_finished.emit()
