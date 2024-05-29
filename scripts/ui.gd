extends Node

const GAME_OVER_SCREEN = preload("res://scenes/game_over_screen.tscn")

func show_game_over():
	var root: Window = get_tree().root
	var screen = GAME_OVER_SCREEN.instantiate()
	root.add_child(screen)
