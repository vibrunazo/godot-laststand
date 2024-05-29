extends Node

const GAME_OVER_SCREEN = preload("res://scenes/game_over_screen.tscn")

var max_health: float = 100
var health: float = 100:
	set(value):
		health = value
		health_changed.emit(value)

signal health_changed(new_value: float)

func show_game_over():
	var root: Window = get_tree().root
	var screen = GAME_OVER_SCREEN.instantiate()
	root.add_child(screen)
