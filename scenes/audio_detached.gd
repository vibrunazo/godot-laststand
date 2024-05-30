extends AudioStreamPlayer2D


func detach_and_play():
	finished.connect(_on_finished)
	play()
	reparent(get_tree().root)
	
func _on_finished():
	queue_free()
