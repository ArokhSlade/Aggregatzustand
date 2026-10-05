@tool
extends "res://player/bubble_state_base.gd"

@export var revolutions_per_second = 1

var angle_diff = 0.0
var rotation_finished = false

func initialize():
	var rotation_ = state_owner.global_rotation
	rotation_finished = false
	state_owner.sprite_2d.global_rotation = rotation_
	angle_diff = state_owner.sprite_2d.transform.x.angle_to(Vector2.RIGHT)


func on_process(delta):
	if is_equal_approx(angle_diff, 0.0):
		rotation_finished = true
	if rotation_finished:
		state_owner.sprite_2d.global_rotation = 0.0
	var angle_delta = 0.0
	if angle_diff > 0.0:
		angle_delta = revolutions_per_second * 2 * PI * delta
		angle_delta = minf(angle_delta, angle_diff) 
		angle_diff -= angle_delta
	else:
		angle_delta = revolutions_per_second * 2 * PI * delta * -1
		angle_delta = maxf(angle_delta, angle_diff)
		angle_diff -= angle_delta
	
	state_owner.sprite_2d.transform = state_owner.sprite_2d.transform.rotated(angle_delta)
