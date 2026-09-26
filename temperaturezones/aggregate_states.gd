extends Resource
class_name AggregateStates

enum Type {
	NONE = 0,
	WATER,
	STEAM
}

@export var TEMP_MIN := 0.0
@export var TEMP_MAX := 100.0

@export var temperature_map : Dictionary[Type, float] = {
	Type.NONE : 50,
	Type.WATER : 0,
	Type.STEAM : 60
}

@export var gravity_curve : Curve

func map_agg_state_to_temp(agg_state):
	
	return temperature_map.get(agg_state, NAN)

func map_temperature_to_gravity_scale(temperature):
	var sample_point = remap(temperature, TEMP_MIN, TEMP_MAX, 0.0, 1.0)
	var gravity_scale = gravity_curve.sample(sample_point)
	return gravity_scale
