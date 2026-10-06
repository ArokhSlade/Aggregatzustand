@tool
extends "res://player/bubble_2/bubble_state_base.gd"

const Utils = preload("uid://djaoinm1vv7kw")

@export var revolutions_per_second = 1
@export var DEBUG_steamy_label : Label

var phases = {}
var phase : Phase

var rotation_override = 0.0

func initialize():
	rotation_override = 0.0
	phase = phases.get("start")


# TODO: move into initialize()
func _ready():
	phases = {
		"start" : Start.new(state_owner, self),
		"rotating" : Rotating.new(state_owner, self),
		"stable" : Stable.new(state_owner, self)
	}
	phase = phases.start


func on_process(delta):
	super(delta)
	phase = phase.on_process(delta)


func rotate_sprite(delta):
	var angle_delta = 0.0
	var angle_diff = 0.0 - rotation_override
	angle_delta = revolutions_per_second * 2 * PI * delta
	angle_delta = minf(angle_delta, abs(angle_diff))
	if angle_diff < 0.0:
		angle_delta *= -1
	DEBUG_steamy_label.modulate = Color.AQUAMARINE
	rotation_override += angle_delta
	state_owner.sprite_2d.global_rotation = rotation_override
	DEBUG_steamy_label.text = "phase: %s\ncurrent_rotation: %s\nangle_delta: %s\nangle_diff: %s" % ["phase", rotation_override, angle_delta, angle_diff]


@abstract class Phase:
	var state_host
	var phase_host
	
	func _init(state_host_, phase_host_):
		state_host = state_host_
		phase_host = phase_host_
	
	@abstract func on_process(delta) -> Phase

class Start extends Phase:
	func on_process(delta):
		if is_equal_approx(state_host.sprite_2d.global_rotation, 0.0):
			phase_host.DEBUG_steamy_label.text = "phase: %s" % ["Start"]
			return phase_host.phases.stable
		else:
			phase_host.rotation_override = state_host.sprite_2d.global_rotation
			phase_host.rotate_sprite(delta)
			if is_equal_approx(state_host.sprite_2d.global_rotation, 0.0):
				return phase_host.phases.stable
			return phase_host.phases.rotating

class Rotating extends Phase:
	func on_process(delta):
		phase_host.rotate_sprite(delta)
		if is_equal_approx(state_host.sprite_2d.global_rotation, 0.0):
			return phase_host.phases.stable
		return self

class Stable extends Phase:
	func on_process(_delta):
		state_host.sprite_2d.global_rotation = 0.0
		phase_host.DEBUG_steamy_label.text = "phase: %s" % ["Stable"]
		return self
