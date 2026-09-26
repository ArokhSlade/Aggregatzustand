extends Resource
class_name AggregateStates

enum Type {
	NONE = 0,
	WATER,
	STEAM
}

@export var temperature_map : Dictionary[Type, float] = {
	Type.NONE : NAN,
	Type.WATER : 1.0,
	Type.STEAM : -0.4
}

func map_agg_state_to_temp(agg_state):
	return temperature_map.get(agg_state, NAN)
