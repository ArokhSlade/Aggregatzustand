extends Node2D

@export var flash_color : Color
@export var desolve_time := 0.26
@export var desolve_curve : Curve


var current_desolve_time := 0.0
var current_dissolve_state := false

var is_mouse_over_object := false
var played_sound := false



func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		dissolve_and_destroy()
	elif event is InputEventScreenTouch and event.pressed:
		dissolve_and_destroy()

func dissolve_and_destroy() -> void:
	current_dissolve_state = true

func _process(delta):
	if Input.is_action_pressed("click") && is_mouse_over_object && !current_dissolve_state:
		current_dissolve_state = true

	if current_dissolve_state:
		current_desolve_time += delta
		var step = current_desolve_time / desolve_time
		$Ground/Hexagon.modulate = flash_color
		$Ground/Hexagon.modulate.a = lerp(1, 0, desolve_curve.sample(step))
		$Ground/StaticBody2D/CollisionPolygon2D.disabled = true

		if step > 0.9:
			$Ground/Area2D.monitoring = false
			current_dissolve_state = false
			$Ground/Hexagon.modulate.a = 0

			if !played_sound:
				$AudioStreamPlayer.play()
				played_sound = true

func _on_area_2d_mouse_entered():
	is_mouse_over_object = true

func _on_area_2d_mouse_exited():
	is_mouse_over_object = false
