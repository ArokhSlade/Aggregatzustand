extends RigidBody2D

const MIN_TEMP = 0
const MAX_TEMP = 100

@export var temperature = 24.
@export var colors : GradientTexture1D
@export var max_speed = 100.

@onready var sprite_2d = $Sprite2D

var speed_scale
var target_temperature
var temperature_speed = 0.5


func _ready():
	target_temperature = temperature


func apply_temperature(temperature_):
	target_temperature = temperature_


func update_temperature(delta):
	temperature = target_temperature
	#temperature = lerp(temperature, target_temperature, 1.0 - exp(-temperature_speed * delta))


#TODO: map it with a curve? gradient?
func temp_to_speed(temp):
	speed_scale = remap(temp, MIN_TEMP, MAX_TEMP, 1.0, -1.0)


#TODO: map it with a curve? gradient?
func temp_to_gravity_scale(temp):
	gravity_scale = remap(temp, MIN_TEMP, MAX_TEMP, 1.0, -1.0)


func update_color():
	sprite_2d.self_modulate = sample_gradient_texture(temperature)


func sample_gradient_texture(temperature_):
	var sample_pos = remap(temperature_, MIN_TEMP, MAX_TEMP, 0, colors.gradient.get_point_count()-1)
	var color = colors.gradient.get_color(sample_pos)
	return color


func _physics_process(delta):
	update_temperature(delta)
	temp_to_speed(temperature)
	temp_to_gravity_scale(temperature)
	update_color()


func _integrate_forces(state: PhysicsDirectBodyState2D):
	#state.linear_velocity.y = speed_scale * max_speed
	pass
