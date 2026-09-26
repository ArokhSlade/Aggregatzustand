extends Node2D

signal player_spawned(player)

@export var start_aggregate_state := AggregateStates.Type.WATER

# initialize()'able dependency
var aggregate_rules : AggregateStates
var player_scene : PackedScene

# working variables
var player 

func initialize(player_scene_, aggregate_rules_):
	player_scene = player_scene_
	aggregate_rules = aggregate_rules_


func spawn():
	player = player_scene.instantiate()
	player_spawned.emit(player)
	player.global_position = global_position
	player.initialize(start_aggregate_state, aggregate_rules)
