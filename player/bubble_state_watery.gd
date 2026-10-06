extends "res://player/bubble_state_base.gd"

@export var DEBUG_watery_label : Label

var rotation_override = 0.
var should_override_rotation = false

func initialize():
	should_override_rotation = true


func on_integrate_forces(physics_state: PhysicsDirectBodyState2D):
	if not should_override_rotation:
		return
	var rotation_ = state_owner.sprite_2d.global_rotation
	rotation_override = rotation_
	var cur_pos = physics_state.transform.get_origin()
	physics_state.transform = Transform2D(rotation_override, cur_pos)
	should_override_rotation = false
