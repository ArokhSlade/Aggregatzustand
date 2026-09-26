extends Area2D

signal level_goal_reached

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("bubble"):
		level_goal_reached.emit()
