extends RigidBody2D

const AggState = AggregateStateProfile.Type
const BubbleState = preload("uid://day47ch14r7tc")
signal aggregate_changed(aggregate_state)

var state
@export var states_map : Dictionary[AggState, BubbleState]

@onready var sprite_2d: Sprite2D = $Sprite2D


func initialize(start_aggregate_state, aggregate_state_profile):
	apply_aggregate_state.call_deferred(start_aggregate_state)


func _on_temperature_sensor_aggregate_changed(aggregate_state: Variant) -> void:
	aggregate_changed.emit(aggregate_state)
	apply_aggregate_state(aggregate_state)


func apply_aggregate_state(agg_state):
	state = states_map.get(agg_state)
	if not state:
		push_error("unknown state")
	state.initialize()
	gravity_scale = state.gravity_scale
	$Sprite2D.material = state.material

func _integrate_forces(physics_state: PhysicsDirectBodyState2D) -> void:
	state.on_integrate_forces(physics_state)

func _process(delta):
	state.on_process(delta)
