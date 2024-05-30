extends Node

signal fullscreen_toggle(state: bool)

const GAME_OVER_SCREEN = preload("res://scenes/game_over_screen.tscn")
const WIN_SCREEN = preload("res://scenes/win_screen.tscn")

func show_game_over():
	var root: Node2D = get_tree().current_scene
	var screen = GAME_OVER_SCREEN.instantiate()
	root.add_child(screen)
	Events.game_over.emit()

func show_win():
	var root: Node2D = get_tree().current_scene
	var screen = WIN_SCREEN.instantiate()
	root.add_child(screen)
	Events.win_level.emit()

func is_fullscreen() -> bool:
	return DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN or DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

func toggle_fullscreen():
	if is_fullscreen():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		UI.fullscreen_toggle.emit(false)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		UI.fullscreen_toggle.emit(true)
