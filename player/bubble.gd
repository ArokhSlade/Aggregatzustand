extends RigidBody2D

const AggState = AggregateStateProfile.Type
const BubbleState = preload("uid://day47ch14r7tc")

signal aggregate_changed(aggregate_state)

@export var states_map : Dictionary[AggState, BubbleState]

@export_category("Debug")
@export var DEBUG_start_aggregate_state = AggState.NONE

@onready var sprite_2d: Sprite2D = $Sprite2D

var state
var initialized = false

func _ready():
	if not initialized:
		push_warning("need to initialize() before _ready()! doing DEBUG fallback initialization...")
		initialize(DEBUG_start_aggregate_state, null)


func initialize(start_agg_state, _agg_states_profile):
	for _state in $States.get_children():
		_state.initialize(self)
	apply_aggregate_state.call_deferred(start_agg_state)
	initialized = true


func _on_temperature_sensor_aggregate_changed(agg_state):
	aggregate_changed.emit(agg_state)
	apply_aggregate_state(agg_state)


func apply_aggregate_state(agg_state):
	state = states_map.get(agg_state)
	if not state:
		push_error("unknown state")
	state.on_enter()
	gravity_scale = state.gravity_scale
	$Sprite2D.material = state.material


func _integrate_forces(physics_state: PhysicsDirectBodyState2D) -> void:
	state.on_integrate_forces(physics_state)


func _process(delta):
	state.on_process(delta)
