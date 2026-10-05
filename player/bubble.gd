extends RigidBody2D

const MIN_TEMP = 0
const MAX_TEMP = 100

@export var colors : GradientTexture1D
@export var max_speed = 100.0
@export var settings : Dictionary[AggregateStateProfile.Type,PlayerSettings]
@export var sprites : Dictionary[AggregateStateProfile.Type, PackedScene]
var sprites_ : Dictionary[AggregateStateProfile.Type, Sprite2D]
@export var prototypes : Dictionary[AggregateStateProfile.Type, Sprite2D]


@export_category("Debug")
## Fallback. should be initialize()'d instead
@export var DEBUG_aggregate_state_profile = preload("uid://mn5f7fwwl6q1")
@export var DEBUG_aggregate_state_override : AggregateStateProfile.Type :
	set(value):
		apply_aggregate_state(value)

@onready var sprite_2d: Sprite2D = $Sprite2D
var sprite : Sprite2D

# initialize()'able dependency
var aggregate_state_profile : AggregateStateProfile

#var state : State

var aggregate_state : AggregateStateProfile.Type
var temperature = 0.0
var speed_scale = 1.0
var target_temperature = 0.0
var temperature_speed = 0.5

var initialized = false

func _enter_tree():
	if not initialized:
		push_warning("Bubble: aggregate_state_profile not initialized. loading fallback aggregate_state_profile.")
		initialize(AggregateStateProfile.Type.WATER, DEBUG_aggregate_state_profile)


# NOTE: for TDD: initialize methods need to be written in a style that they can be called before _ready(). maybe call them pre_ready_init()?
func initialize(aggregte_state_, aggregate_state_profile_):
	aggregate_state_profile = aggregate_state_profile_
	for agg_state in sprites.keys():
		sprites_[agg_state] = sprites[agg_state].instantiate()
	apply_aggregate_state.call_deferred(aggregte_state_)
	initialized = true


func apply_aggregate_state(aggregate_state_):
	if not aggregate_state_profile:
		aggregate_state_profile = DEBUG_aggregate_state_profile
	if not aggregate_state_profile:
		push_error("Bubble: cannot apply aggregate state without an AggregateStateProfile.")
		return

	aggregate_state = aggregate_state_
	temperature = aggregate_state_profile.map_agg_state_to_temp(aggregate_state)
	temp_to_gravity_scale(temperature)
	
	for prototype in $Prototypes.get_children():
		$Prototypes.remove_child(prototype)
	$SpriteParent.remove_child(sprite)
	sprite = prototypes[aggregate_state]
	$SpriteParent.add_child(sprite)
	
	#apply_settings()


func apply_settings():
	if not settings.has(aggregate_state):
		push_warning("bubble::apply_settings: no settings exist for aggregate_state %s." % [aggregate_state])
		return
	var settings_ = settings[aggregate_state]
	sprite_2d.material = settings_.material
	sprite_2d.texture = settings_.texture


func apply_temperature_immediately(temperature_):
	target_temperature = temperature_


func _on_temperature_sensor_aggregate_changed(aggregate_state_):
	apply_aggregate_state(aggregate_state_)


func update_temperature(_delta):
	temperature = target_temperature
	#temperature = lerp(temperature, target_temperature, 1.0 - exp(-temperature_speed * delta))


# DEPRECATED
func temp_to_speed_scale(temp):
	speed_scale = aggregate_state_profile.map_temperature_to_gravity_scale(temp)


func temp_to_gravity_scale(temp):
	gravity_scale = aggregate_state_profile.map_temperature_to_gravity_scale(temp)


func update_color():
	# sprite_2d.self_modulate = sample_gradient_texture(temperature)
	pass


func sample_gradient_texture(temperature_):
	var sample_pos = remap(temperature_, MIN_TEMP, MAX_TEMP, 0, colors.gradient.get_point_count()-1)
	var color = colors.gradient.get_color(sample_pos)
	return color


func _process(_delta):
	sprite_2d.global_position = global_position
	sprite.global_position = global_position


func _physics_process(delta):
	update_temperature(delta)
	#temp_to_speed_scale(temperature)
	
	update_color()


#class State:
	#var owner
	#func _init(owner_):
		#owner = owner_
	#func on_process():
		#owner.sprite.global_position = global_position
	#func on_physics_process(): 
		#owner.update_temperature(delta)
		#pass
	##func apply_aggregate
	#func on_enter():
		#owner.gravity_scale = aggregate_state_profile.map_temperature_to_gravity_scale(temp)
	#func on_exit():
		#pass
#
#class Watery extends State:
	##func 
	#pass
