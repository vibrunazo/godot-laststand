class_name ArtStand
extends Sprite2D

signal clicked


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_button_down():
	clicked.emit()
