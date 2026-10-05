extends RigidBody2D

@export var map_prototypes : Dictionary[AggregateStateProfile.Type, Sprite2D]

@export_category("Debug")
## Fallback. should be initialize()'d instead
@export var DEBUG_aggregate_state_profile = preload("uid://mn5f7fwwl6q1")
@export var DEBUG_aggregate_state_override : AggregateStateProfile.Type :
	set(value):
		apply_aggregate_state(value)

# initialize()'able dependency
var aggregate_state_profile : AggregateStateProfile

var aggregate_state : AggregateStateProfile.Type
var sprite : Sprite2D
var initialized = false
#var state : State

func _enter_tree():
	if not initialized:
		push_warning("Bubble: aggregate_state_profile not initialized. loading fallback aggregate_state_profile.")
		initialize(AggregateStateProfile.Type.WATER, DEBUG_aggregate_state_profile)


# NOTE: for TDD: initialize methods need to be written in a style that they can be called before _ready(). maybe call them pre_ready_init()?
func initialize(aggregte_state_, aggregate_state_profile_):
	aggregate_state_profile = aggregate_state_profile_
	for agg_state in map_prototypes.keys():
		map_prototypes[agg_state].owner = null # NOTE: to avoid godot warning when we later attach to different parent
		$Prototypes.remove_child(map_prototypes[agg_state])
	init_apply_aggregate_state(aggregte_state_)
	initialized = true


func init_apply_aggregate_state(aggregate_state_):
	if not aggregate_state_profile:
		if not DEBUG_aggregate_state_profile:
			push_error("Bubble: cannot apply aggregate state without an AggregateStateProfile.")
			return
		aggregate_state_profile = DEBUG_aggregate_state_profile

	aggregate_state = aggregate_state_
	var temperature = get_temperature()
	temp_to_gravity_scale(temperature)
	
	sprite = map_prototypes[aggregate_state]
	$SpriteParent.add_child(sprite)


func apply_aggregate_state(aggregate_state_):
	if not aggregate_state_profile:
		push_error("Bubble: cannot apply aggregate state without an AggregateStateProfile.")
		return

	aggregate_state = aggregate_state_
	var temperature = get_temperature()
	temp_to_gravity_scale(temperature)
	
	$SpriteParent.remove_child(sprite)
	sprite = map_prototypes[aggregate_state]
	$SpriteParent.add_child(sprite)


func _on_temperature_sensor_aggregate_changed(aggregate_state_):
	apply_aggregate_state(aggregate_state_)


func temp_to_gravity_scale(temp):
	gravity_scale = aggregate_state_profile.map_temperature_to_gravity_scale(temp)


func _process(_delta):
	sprite.global_position = global_position


func get_temperature():
	var temperature = aggregate_state_profile.map_agg_state_to_temp(aggregate_state)
	return temperature


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
