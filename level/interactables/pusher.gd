extends Node2D

@export var strength: float = 100

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

func push():
	for node in nodes_to_push:
		node.apply_force(to_global(Vector2.RIGHT) * strength)

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
