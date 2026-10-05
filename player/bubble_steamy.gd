@tool
extends "res://player/bubble_base.gd"

@export var revolutions_per_second = 1

var angle_diff = 0.0
var rotation_finished = false

@export var DEBUG_rotation = -PI :
	set(value):
		DEBUG_rotation = value
		initialize(value)
@export_tool_button("rotate", "Reload") var DEBUG_rotate = Callable(initialize).bind(DEBUG_rotation)

func initialize(rotation_ = 0):
	rotation_finished = false
	$Sprite2D.global_rotation = rotation_
	angle_diff = $Sprite2D.transform.x.angle_to(Vector2.RIGHT)


func _process(delta):
	if is_equal_approx(angle_diff, 0.0):
		rotation_finished = true
	if rotation_finished:
		$Sprite2D.global_rotation = 0.0
	var angle_delta = 0.0
	if angle_diff > 0.0:
		angle_delta = revolutions_per_second * 2 * PI * delta
		angle_delta = minf(angle_delta, angle_diff) 
		angle_diff -= angle_delta
	else:
		angle_delta = revolutions_per_second * 2 * PI * delta * -1
		angle_delta = maxf(angle_delta, angle_diff)
		angle_diff -= angle_delta
	
	$Sprite2D.transform = $Sprite2D.transform.rotated(angle_delta)
