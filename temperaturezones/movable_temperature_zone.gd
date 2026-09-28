extends temperature_zone


var is_mouse_inside: bool = false
var is_dragged: bool = false
var drag_offset: float

var current_state
var states = {
	"Default" : Default.new(self),
	"Dragging" : Dragging.new(self)
}

func _ready():
	current_state = states.Default


func _physics_process(delta: float) -> void:
	super._physics_process(delta)


func _process(delta: float) -> void:
	if is_dragged:
		global_position.x = get_global_mouse_position().x - drag_offset


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click") and is_mouse_inside:
		is_dragged = true
		drag_offset = get_local_mouse_position().x
	elif event.is_action_released("click"):
		is_dragged = false


func _on_mouse_entered() -> void:
	is_mouse_inside = true


func _on_mouse_exited() -> void:
	is_dragged = false
	is_mouse_inside = false


func switch_state(new_state):
	if new_state == current_state:
		return
	current_state.on_exit()
	current_state = new_state
	current_state.on_enter()


@abstract class State:
	var owner
	
	@abstract func _handle_input_event(viewport : Node, event : InputEvent, shape_index : int)
	
	func _init(owner_):
		owner = owner_
	
	
class Default extends State:
	func _handle_input_event(viewport : Node, event : InputEvent, shape_index : int):
		owner.switch_state(owner.states.Dragging)
		
class Dragging extends State:
	func _handle_input_event(viewport : Node, event : InputEvent, shape_index : int): 
		var pos
		owner.move_to(pos)
