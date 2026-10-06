extends Node2D

signal player_spawned(player)

@export var start_aggregate_state := AggregateStateProfile.Type.WATER

# initialize()'able dependency
var aggregate_state_profile : AggregateStateProfile
var player_scene : PackedScene

# working variables
var player

func initialize(player_scene_, aggregate_state_profile_):
	player_scene = player_scene_
	aggregate_state_profile = aggregate_state_profile_


func spawn_player():
	player = player_scene.instantiate()
	player.global_position = global_position
	player.initialize(start_aggregate_state, aggregate_state_profile)
	player_spawned.emit(player)
