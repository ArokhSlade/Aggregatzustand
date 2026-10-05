extends RigidBody2D

const AggState = AggregateStateProfile.Type

signal aggregate_changed(aggregate_state)

var state

func initialize(rotation_):
	state.initialize(rotation_)


func _on_temperature_sensor_aggregate_changed(aggregate_state: Variant) -> void:
	aggregate_changed.emit(aggregate_state)


func apply_aggregate_state(agg_state):
	pass

func _integrate_forces(physics_state: PhysicsDirectBodyState2D):
	state.on_integrate_forces(physics_state)

func _process(delta):
	state.on_process(delta)
