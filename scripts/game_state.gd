extends Node


var max_health: float = 100
var health: float = 100:
	set(value):
		health = value
		health_changed.emit(value)

signal health_changed(new_value: float)

