extends RigidBody2D

@export var map_prototypes : Dictionary[AggregateStateProfile.Type, Sprite2D]

@export_category("Debug")
## Fallback. should be initialize()'d instead
@export var DEBUG_aggregate_state_profile = preload("uid://mn5f7fwwl6q1")
@export var DEBUG_aggregate_state_override : AggregateStateProfile.Type :
	set(value):
		apply_aggregate_state(value)

const AggState = AggregateStateProfile.Type
var states = {
	AggState.WATER : Watery.new(self),
	AggState.STEAM : Steamy.new(self)
}

# initialize()'able dependency
var aggregate_state_profile : AggregateStateProfile

var aggregate_state : AggregateStateProfile.Type
var sprite : Sprite2D
var initialized = false
var state : State

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
	state = states[aggregate_state]


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
	
	transition_to(aggregate_state_)


func transition_to(agg_state):
	var new_state = states.get(agg_state)
	if not new_state:
		push_error("transition_to: invalid new state")
		return
	state.on_exit()
	new_state.on_enter(state.get_data())
	state = new_state


func _on_temperature_sensor_aggregate_changed(aggregate_state_):
	apply_aggregate_state(aggregate_state_)


func temp_to_gravity_scale(temp):
	gravity_scale = aggregate_state_profile.map_temperature_to_gravity_scale(temp)


func _integrate_forces(physics_state: PhysicsDirectBodyState2D) -> void:
	state.on_integrate_forces(physics_state)


func _process(_delta):
	sprite.global_position = global_position


func get_temperature():
	var temperature = aggregate_state_profile.map_agg_state_to_temp(aggregate_state)
	return temperature


class State:
	var owner
	func _init(owner_):
		owner = owner_
	func on_process():
		pass
	func on_physics_process(): 
		pass
	func on_integrate_forces(physics_state):
		pass
	#func apply_aggregate
	func on_enter(data):
		pass
	func on_exit():
		pass
	func get_data():
		return {}

class Watery extends State:
	var target_rotation = PI
	var rotation_reset = false
	
	func on_enter(data):
		rotation_reset = false
		target_rotation = PI
		copy_sprite_rotation_to_physics_body(data.sprite_2d.rotation)
	
	func copy_sprite_rotation_to_physics_body(rotation_):
		target_rotation = rotation_
	
	func on_integrate_forces(physics_state : PhysicsDirectBodyState2D):
		if not rotation_reset:
			owner.rotation = target_rotation
			rotation_reset = true


class Steamy extends State:
	func get_data():
		return {
			"sprite_2d" : owner.map_prototypes.get(AggState.STEAM)
		}
	pass
