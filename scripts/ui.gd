extends Node

signal fullscreen_toggle(state: bool)

const GAME_OVER_SCREEN = preload("res://scenes/game_over_screen.tscn")

func show_game_over():
	var root: Window = get_tree().root
	var screen = GAME_OVER_SCREEN.instantiate()
	root.add_child(screen)
