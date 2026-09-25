extends RigidBody2D

const MIN_TEMP = 0
const MAX_TEMP = 100

@export var temperature = 24.
@export var colors : GradientTexture1D

@onready var sprite_2d = $Sprite2D

#TODO: map it with a curve? gradient?
func temp_to_gravity_scale(temp):
	gravity_scale = remap(temp, MIN_TEMP, MAX_TEMP, 1, -1)


func update_color():
	sprite_2d.self_modulate = sample_gradient_texture(temperature)


func sample_gradient_texture(temperature_):
	var sample_pos = remap(temperature_, MIN_TEMP, MAX_TEMP, 0, colors.gradient.get_point_count()-1)	
	var color = colors.gradient.get_color(sample_pos)
	return color


func _physics_process(_delta):
	temp_to_gravity_scale(temperature)
	update_color()
