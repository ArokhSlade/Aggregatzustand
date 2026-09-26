extends Area2D

signal temperature_changed(temperature)

func apply_temperature(temperature_):
	temperature_changed.emit(temperature_)
