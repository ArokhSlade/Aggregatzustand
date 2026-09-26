extends Area2D
class_name temperature_zone

@export var temperature = 24.0

func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		#try_apply_temperature(body, temperature)
		pass


func _on_area_entered(area):
	try_apply_temperature(area)


func try_apply_temperature(target):
	if target.has_method("apply_temperature"):
		target.apply_temperature(temperature)
		#body_.update_color()
