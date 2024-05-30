extends Node

var is_playing: bool = false
var money: float = 0:
	set(value):
		money = value
		money_changed.emit(value)
		
signal money_changed(new_value: float)


var max_health: float = 100
var health: float = 100:
	set(value):
		health = value
		health_changed.emit(value)

signal health_changed(new_value: float)

