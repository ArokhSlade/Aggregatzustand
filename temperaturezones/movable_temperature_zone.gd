extends temperature_zone

var state
var states = {
	"Default" : Default.new(self),
	"Dragging" : Dragging.new(self)
}

func _ready():
	super()
	state = states.Default


func _physics_process(delta: float) -> void:
	super._physics_process(delta)


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

# TODO: clamped horizontal movement 
func move_to(pos_):
	global_position.x = pos_.x


func switch_state(new_state):
	if new_state == state:
		return
	state = new_state


@abstract class State:
	var owner
	func on_pointer_just_pressed(event : InputEventMouseButton):
		pass
	func on_pointer_released(event : InputEventMouseButton):
		pass
	func on_pointer_moved(event : InputEventMouseMotion):
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
	
	func on_pointer_released(event : InputEventMouseButton):
		owner.switch_state(owner.states.Default)
	
	func on_pointer_moved(event : InputEventMouseMotion):
		var pos = event.global_position
		pos.x -= offset.x
		owner.move_to(pos)
