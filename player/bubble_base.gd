extends RigidBody2D

signal aggregate_changed(aggregate_state)

func _on_temperature_sensor_aggregate_changed(aggregate_state: Variant) -> void:
	aggregate_changed.emit(aggregate_state)
