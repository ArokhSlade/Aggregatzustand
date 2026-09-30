extends Node2D

@export var strength: float = 100

@export_category("DEBUG")
@export var DEBUG_draw_push_vector = false
@export var alpha_rad = PI * .5
@export var corner_length = 50.
@export var arrow_length = 100.

var nodes_to_push: Array[RigidBody2D]
var is_pushing: bool = false
var active_touch_id := -1


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is RigidBody2D:
		$Arrow.visible = false
		nodes_to_push.erase(body)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is RigidBody2D and nodes_to_push.find(body) == -1:
		$Arrow.visible = true
		nodes_to_push.append(body)


func _process(delta: float) -> void:
	if is_pushing:
		push()
	queue_redraw()


func push():
	for node in nodes_to_push:
		node.apply_force(get_push_vector() * strength)


func get_push_vector():
	var push_vector = Vector2.RIGHT
	return push_vector


func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			active_touch_id = event.index
			start_pushing()
		elif event.index == active_touch_id:
			active_touch_id = -1
			stop_pushing()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start_pushing()
		else:
			stop_pushing()


func _input(event: InputEvent) -> void:
	# Screen-touch releases are not guaranteed to be delivered to ClickArea when
	# the finger is lifted outside its collision shape.
	if event is InputEventScreenTouch and not event.pressed and event.index == active_touch_id:
		active_touch_id = -1
		stop_pushing()


func start_pushing() -> void:
	if is_pushing:
		return

	is_pushing = true
	$AudioStreamPlayer2D.play(0)
	$Schnuffi/AnimationPlayer.play("pusten")


func stop_pushing() -> void:
	is_pushing = false


func _on_click_area_mouse_exited() -> void:
	if active_touch_id == -1:
		stop_pushing()
	#$Schnuffi/AnimationPlayer.play("RESET")


func _draw():
	if DEBUG_draw_push_vector:
		var from = Vector2.ZERO
		var to = get_push_vector() * arrow_length
		draw_arrow(from, to, Color.WHITE)


func draw_arrow(from, to, color):
	draw_line(from, to, color)
	var ba = from - to
	ba = ba.normalized()
	ba *= corner_length
	var rotator_left : Transform2D
	rotator_left.x.x = cos(alpha_rad)
	rotator_left.x.y = sin(alpha_rad)
	rotator_left.y.x = -sin(alpha_rad)
	rotator_left.y.y = cos(alpha_rad)
	var corner_left = rotator_left * ba
	corner_left = to + corner_left
	draw_line(corner_left, to, color)
	var rotator_right : Transform2D
	rotator_right.x.x = cos(alpha_rad)
	rotator_right.x.y = -sin(alpha_rad)
	rotator_right.y.x = sin(alpha_rad)
	rotator_right.y.y = cos(alpha_rad)
	var corner_right = rotator_right * ba
	corner_right = to + corner_right
	draw_line(to, corner_right, color)
