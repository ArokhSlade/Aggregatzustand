extends Area2D
class_name temperature_zone

@export var temperature = 24.0

func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		#try_apply_temperature(body, temperature)
		pass


func _on_body_entered(body):
	try_apply_temperature(body, temperature)


func try_apply_temperature(body_, temperature_):
	if body_.has_method("apply_temperature"):
		body_.apply_temperature(temperature_)
		#body_.update_color()
