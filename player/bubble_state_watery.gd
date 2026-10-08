extends "res://player/bubble_state_base.gd"

@export var DEBUG_watery_label : Label

var should_override_rotation = false

func initialize(state_owner_):
	super(state_owner_)
	
	should_override_rotation = true


func on_integrate_forces(physics_state: PhysicsDirectBodyState2D):
	if not should_override_rotation:
		return
	var rotation_override = state_owner.sprite_2d.global_rotation
	var cur_pos = physics_state.transform.get_origin()
	physics_state.transform = Transform2D(rotation_override, cur_pos)
	state_owner.sprite_2d.transform = Transform2D.IDENTITY
	should_override_rotation = false
	rotation_override = 0.
