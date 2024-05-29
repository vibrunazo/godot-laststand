extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_key_input(event):
	if event.is_action_pressed('ui_fullscreen'):
		toggle_fullscreen()
	elif event.is_action_pressed("debug_speed"):
		toggle_debug_speed()
	elif event.is_action_pressed("debug_test"):
		debug_test()
		
func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN or DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		UI.fullscreen_toggle.emit(false)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		UI.fullscreen_toggle.emit(true)

func toggle_debug_speed():
	if Engine.time_scale != 1:
		Engine.time_scale = 1
	else:
		Engine.time_scale = 5
	print('time scale is %s' % [Engine.time_scale])

func debug_test():
	GameState.show_game_over()
