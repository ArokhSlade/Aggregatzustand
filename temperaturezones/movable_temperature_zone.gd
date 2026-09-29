extends temperature_zone


var is_mouse_inside: bool = false
var is_dragged: bool = false
var drag_offset: float

var state
var states = {
	"Default" : Default.new(self),
	"Dragging" : Dragging.new(self)
}

func _ready():
	state = states.Default


func _physics_process(delta: float) -> void:
	super._physics_process(delta)


func _process(delta: float) -> void:
	if is_dragged:
		global_position.x = get_global_mouse_position().x - drag_offset


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("input")
	if event.is_action_pressed("click") and is_mouse_inside:
		print("drag")
		is_dragged = true
		drag_offset = get_local_mouse_position().x
	elif event.is_action_released("click"):
		print("drop")
		is_dragged = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		print("mouse")
		if event is InputEventMouseMotion:
			print("mouse motion")
			state.on_pointer_moved(event)
		

func _on_mouse_entered() -> void:
	print("mouse enter")
	is_mouse_inside = true


func _on_mouse_exited() -> void:
	print("mouse exit")
	is_dragged = false
	is_mouse_inside = false


func switch_state(new_state):
	if new_state == state:
		return
	state.on_exit()
	state = new_state
	state.on_enter()


@abstract class State:
	var owner
	
	@abstract func on_pointer_just_pressed(event : InputEvent)
	@abstract func on_pointer_just_released(event : InputEvent)
	@abstract func on_pointer_moved(event : InputEventMouseMotion)
	
	func _init(owner_):
		owner = owner_
	
	
class Default extends State:
	func on_pointer_just_pressed(event : InputEvent):
		owner.switch_state(owner.states.Dragging)
		
	func on_pointer_just_released(event : InputEvent):
		return
	
	func on_pointer_moved(event : InputEventMouseMotion):
		return


class Dragging extends State:
	func on_pointer_just_pressed(event : InputEvent):
		var pos
		owner.move_to(pos)
	
	func on_pointer_just_released(event : InputEvent):
		owner.switch_state(owner.states.Default)
	
	func on_pointer_moved(event : InputEventMouseMotion):
		print("dragging at %s" % [str(event.global_position)])
