extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_key_input(event):
	if event.is_action_pressed('ui_fullscreen'):
		UI.toggle_fullscreen()
	elif event.is_action_pressed("debug_speed"):
		toggle_debug_speed()
	elif event.is_action_pressed("debug_test"):
		debug_test()
		
func toggle_debug_speed():
	if Engine.time_scale != 1:
		Engine.time_scale = 1
	else:
		Engine.time_scale = 5
	print('time scale is %s' % [Engine.time_scale])

func debug_test():
	pass
	#UI.show_game_over()
	#UI.show_win()
