extends RigidBody2D

const MIN_TEMP = 0
const MAX_TEMP = 100

@export var colors : GradientTexture1D
@export var max_speed = 100.0

## Fallback. should be initialize()'d instead
@export var DEBUG_aggregate_state_profile = preload("uid://mn5f7fwwl6q1")

@onready var sprite_2d = $Sprite2D

# initialize()'able dependency
var aggregate_state_profile : AggregateStateProfile

var aggregate_state : AggregateStateProfile.Type
var temperature = 0.0
var speed_scale = 1.0
var target_temperature = 0.0
var temperature_speed = 0.5
var initialized = false

func _enter_tree():
	if not initialized:
		push_warning("Bubble: aggregate_state_profile not initialized. Loading fallback aggregate_state_profile.")
		initialize(AggregateStateProfile.Type.WATER, DEBUG_aggregate_state_profile)


func initialize(aggregte_state_, aggregate_state_profile_):
	aggregate_state_profile = aggregate_state_profile_ if aggregate_state_profile_ else DEBUG_aggregate_state_profile
	if not aggregate_state_profile:
		push_error("Bubble: no AggregateStateProfile is available.")
		return

	apply_aggregate_state(aggregte_state_)
	initialized = true


func apply_aggregate_state(aggregate_state_):
	if not aggregate_state_profile:
		aggregate_state_profile = DEBUG_aggregate_state_profile
	if not aggregate_state_profile:
		push_error("Bubble: cannot apply aggregate state without an AggregateStateProfile.")
		return

	aggregate_state = aggregate_state_
	temperature = aggregate_state_profile.map_agg_state_to_temp(aggregate_state)
	apply_temperature_immediately(temperature)

	if aggregate_state == AggregateStateProfile.Type.WATER:
		$gas_2d_character.visible = false
		$water_charcter.visible = true
	else:
		$gas_2d_character.visible = true
		$water_charcter.visible = false


func apply_temperature_immediately(temperature_):
	target_temperature = temperature_


func _on_temperature_sensor_aggregate_changed(aggregate_state_):
	apply_aggregate_state(aggregate_state_)


# DEPRECATED
func apply_temperature(temperature_):
	target_temperature = temperature_


# DEPRECATED
func update_temperature(_delta):
	temperature = target_temperature
	#temperature = lerp(temperature, target_temperature, 1.0 - exp(-temperature_speed * delta))


# DEPRECATED
func temp_to_speed_scale(temp):
	speed_scale = aggregate_state_profile.map_temperature_to_gravity_scale(temp)


func temp_to_gravity_scale(temp):
	gravity_scale = aggregate_state_profile.map_temperature_to_gravity_scale(temp)


func update_color():
	sprite_2d.self_modulate = sample_gradient_texture(temperature)


func sample_gradient_texture(temperature_):
	var sample_pos = remap(temperature_, MIN_TEMP, MAX_TEMP, 0, colors.gradient.get_point_count()-1)
	var color = colors.gradient.get_color(sample_pos)
	return color


func _physics_process(delta):
	update_temperature(delta)
	#temp_to_speed_scale(temperature)
	temp_to_gravity_scale(temperature)
	update_color()


func _integrate_forces(_state: PhysicsDirectBodyState2D):
	#state.linear_velocity.y = speed_scale * max_speed
	pass
