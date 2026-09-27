extends Area2D

signal aggregate_changed(aggregate_state)

func apply_aggregate_state(aggregate_state_):
	aggregate_changed.emit(aggregate_state_)
