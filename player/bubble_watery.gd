extends "res://player/bubble_state_base.gd"

var rotation_override = 0.
var should_override_rotation = false

func initialize(rotation_):
	rotation_override = rotation_
	should_override_rotation = true

func on_integrate_forces(physics_state: PhysicsDirectBodyState2D):
	if not should_override_rotation:
		return
	var cur_pos = physics_state.transform.get_origin()
	physics_state.transform = Transform2D(rotation_override, cur_pos)
	should_override_rotation = false
