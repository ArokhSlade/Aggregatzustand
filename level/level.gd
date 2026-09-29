extends Node2D

signal level_finished

@export var player_scene : PackedScene
@export var level_start : Node2D

@export var DEBUG_aggregate_state_profile : AggregateStateProfile

## external dependency that must be initialize()'d
var aggregate_state_profile : AggregateStateProfile

var player
var initialized = false

func _ready():
	if not initialized:
		DEBUG_fallback_initialize()


func initialize(aggregate_state_profile_):
	aggregate_state_profile = aggregate_state_profile_
	
	if not player_parent:
		player_parent = self
	
	if level_start:
		level_start.initialize(player_scene, aggregate_state_profile)
		level_start.spawn_player()
	
	initialized = true


func pause():
	set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)


func unpause():
	set_process_mode.call_deferred(Node.PROCESS_MODE_PAUSABLE)


func DEBUG_fallback_initialize():
	initialize(DEBUG_aggregate_state_profile)


func _on_level_start_player_spawned(player_):
	add_child(player_)
	player = player_


func _on_level_goal_level_goal_reached():
	level_finished.emit()
