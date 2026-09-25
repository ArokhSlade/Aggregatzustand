extends RigidBody2D

@export var temperature = 24.

func temp_to_gravity_scale(temp):
	gravity_scale = remap(temp, 0, 100, 1, -1)


func _physics_process(delta):
	temp_to_gravity_scale(temperature)
