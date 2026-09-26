extends Area2D
class_name temperature_zone

@export var temperature = 24.0

func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.has_method("apply_temperature"):
			body.apply_temperature(temperature)
