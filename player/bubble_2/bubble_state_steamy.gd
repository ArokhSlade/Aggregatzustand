@tool
extends "res://player/bubble_2/bubble_state_base.gd"

const Utils = preload("uid://djaoinm1vv7kw")

@export var revolutions_per_second = 1
@export var DEBUG_steamy_label : Label

enum Phase {
	START, ROTATING, STABLE
}
enum RotDir {
	NONE, CCW, CW
}

var phase := Phase.START
var angle_diff = 0.0
var rot_dir := RotDir.NONE
var rotation_override = 0.0

func initialize():
	phase = Phase.START
	
func to_stable():
	state_owner.sprite_2d.global_rotation = 0.0
	phase = Phase.STABLE
	rotation_override = 0.0
	rot_dir = RotDir.NONE
	angle_diff = 0.0


func on_process(delta):
	match phase:
		Phase.START:
			if is_equal_approx(state_owner.sprite_2d.global_rotation, 0.0):
				to_stable()
				DEBUG_steamy_label.text = "phase: %s" % [Utils.enum_to_str(phase, Phase)]
			else:
				phase = Phase.ROTATING
				rotation_override = state_owner.sprite_2d.global_rotation
				rotate_sprite(delta)
		Phase.ROTATING:
			rotate_sprite(delta)
		Phase.STABLE:
			state_owner.sprite_2d.global_rotation = 0.0
			DEBUG_steamy_label.text = "phase: %s" % [Utils.enum_to_str(phase, Phase)]
		_:
			DEBUG_steamy_label.text = "phase: %s" % [Utils.enum_to_str(phase, Phase)]
	super(delta)

func rotate_sprite(delta):
	var angle_delta = 0.0
	angle_diff = 0.0 - rotation_override
	angle_delta = revolutions_per_second * 2 * PI * delta
	angle_delta = minf(angle_delta, abs(angle_diff))
	if angle_diff < 0.0:
		angle_delta *= -1
	DEBUG_steamy_label.modulate = Color.AQUAMARINE
	rotation_override += angle_delta
	state_owner.sprite_2d.global_rotation = rotation_override
	if is_equal_approx(state_owner.sprite_2d.global_rotation, 0.0):
		to_stable()
	DEBUG_steamy_label.text = "phase: %s\ncurrent_rotation: %s\nangle_delta: %s\nangle_diff: %s\nrot_dir: %s" % [Utils.enum_to_str(phase, Phase), rotation_override, angle_delta, angle_diff, Utils.enum_to_str(rot_dir, RotDir)]
