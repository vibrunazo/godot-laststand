class_name ArtStand
extends Sprite2D

signal clicked


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
var click_tween: Tween
func anim_click():
	click_tween = create_tween()
	click_tween.set_ease(Tween.EASE_IN_OUT)
	click_tween.set_trans(Tween.TRANS_QUAD)
	click_tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	click_tween.set_ease(Tween.EASE_OUT)
	click_tween.set_trans(Tween.TRANS_ELASTIC)
	click_tween.tween_property(self, "scale", Vector2(1, 1), 0.4)
	

func _on_button_down():
	clicked.emit()
	anim_click()
