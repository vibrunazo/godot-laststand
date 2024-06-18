class_name Vfx
extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	print('im a muzzle flash')


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "start":
		queue_free()
