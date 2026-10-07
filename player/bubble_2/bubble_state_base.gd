extends Node

const AggState = AggregateStateProfile.Type

@export var material : Material
@export var gravity_scale : float

@export_category("Debug")
@export var DEBUG_base_label : Label

var state_owner : Node

func initialize(state_owner_):
	state_owner = state_owner_

func on_enter():
	pass

func on_integrate_forces(_physics_state):
	pass

func on_process(_delta):
	DEBUG_base_label.text = "body_rotation: %s\nsprite_rotation %s" % [state_owner.global_rotation, state_owner.sprite_2d.global_rotation]
	pass
