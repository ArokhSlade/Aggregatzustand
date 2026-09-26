extends Node2D

signal player_spawned(player)

@export var start_aggregate_state := AggregateStates.Type.WATER

var player_scene : PackedScene
var player 

func initialize(player_scene_):
	player_scene = player_scene_

func spawn():
	player = player_scene.instantiate()
	player_spawned.emit(player)
	player.global_position = global_position
	#player.apply_temperature_immediately(start_temperature)
