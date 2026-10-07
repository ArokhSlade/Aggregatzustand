extends Node

const AggState = AggregateStateProfile.Type

@export var material : Material
@export var gravity_scale : float

@export var state_owner : Node

@export var DEBUG_base_label : Label

func initialize():
	pass

func on_integrate_forces(_physics_state):
	pass

func on_process(_delta):
	DEBUG_base_label.text = "body_rotation: %s\nsprite_rotation %s" % [state_owner.global_rotation, state_owner.sprite_2d.global_rotation]
	pass
