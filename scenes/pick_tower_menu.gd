class_name PickTowerMenu
extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	anim_start()


var anim_tween: Tween
func anim_start():
	scale = Vector2(0, 0)
	anim_tween = create_tween()
	anim_tween.set_ease(Tween.EASE_OUT)
	anim_tween.set_trans(Tween.TRANS_ELASTIC)
	anim_tween.tween_property(self, "scale", Vector2(1,1), 0.9)

func anim_end():
	anim_tween = create_tween()
	anim_tween.set_ease(Tween.EASE_OUT)
	anim_tween.set_trans(Tween.TRANS_QUAD)
	anim_tween.tween_property(self, "scale", Vector2(0,0), 0.2)
	await anim_tween.finished
	queue_free()
