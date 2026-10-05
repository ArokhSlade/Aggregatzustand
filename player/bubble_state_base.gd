extends Node

const AggState = AggregateStateProfile.Type

signal aggregate_changed(aggregate_state)

@export var material : Material
@export var gravity_scale : float

@export var state_owner : Node

func initialize():
	pass

func on_integrate_forces(physics_state):
	pass

func on_process(delta):
	pass
