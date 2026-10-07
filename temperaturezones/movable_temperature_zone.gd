extends temperature_zone

@export var left_boundary : Node2D
@export var right_boundary : Node2D

var state
var states = {
	"Default" : Default.new(self),
	"Dragging" : Dragging.new(self)
}

func _ready():
	super()
	state = states.Default


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			state.on_pointer_just_pressed(event)
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event is InputEventMouseMotion:
			state.on_pointer_moved(event)
		elif event is InputEventMouseButton:
			if event.is_action_released("click"):
				state.on_pointer_released(event)


func move_to(pos_):
	global_position.x = pos_.x
	var x_offset = transform.get_scale().x * get_half_extents().x
	var min_x = left_boundary.global_position.x + x_offset if left_boundary else null
	var max_x = right_boundary.global_position.x - x_offset if right_boundary else null
	if left_boundary and right_boundary:
		global_position.x = clampf(pos_.x, min_x, max_x)
	elif left_boundary:
		global_position.x = maxf(pos_.x, min_x)
	elif right_boundary:
		global_position.x = minf(pos_.x, max_x)


func switch_state(new_state):
	if new_state == state:
		return
	state = new_state


@abstract class State:
	var owner
	func on_pointer_just_pressed(_event : InputEventMouseButton):
		pass
	func on_pointer_released(_event : InputEventMouseButton):
		pass
	func on_pointer_moved(_event : InputEventMouseMotion):
		pass
	
	func _init(owner_):
		owner = owner_
	
	
class Default extends State:
	func on_pointer_just_pressed(event : InputEventMouseButton):
		var offset = event.global_position - owner.global_position
		owner.states.Dragging.initialize(offset)
		owner.switch_state(owner.states.Dragging)


class Dragging extends State:
	var offset
	
	func initialize(offset_):
		offset = offset_
	
	func on_pointer_released(_event : InputEventMouseButton):
		owner.switch_state(owner.states.Default)
	
	func on_pointer_moved(event : InputEventMouseMotion):
		var pos = event.global_position
		pos.x -= offset.x
		owner.move_to(pos)
