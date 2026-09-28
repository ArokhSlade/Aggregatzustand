extends Node2D

@export var strength: float = 100

var nodes_to_push: Array[RigidBody2D]
var is_pushing: bool = false

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
	if event.is_action_pressed("click"):
		is_pushing = true
		$AudioStreamPlayer2D.play(0)
		$Schnuffi/AnimationPlayer.play("pusten")
	if event.is_action_released("click"):
		is_pushing = false
		#$Schnuffi/AnimationPlayer.play("RESET")


func _on_click_area_mouse_exited() -> void:
	is_pushing = false
	#$Schnuffi/AnimationPlayer.play("RESET")
