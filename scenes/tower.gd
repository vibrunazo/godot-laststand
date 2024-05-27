@icon("res://assets/tex/canvas.png")
class_name Tower
extends Node2D


var is_being_placed: bool = true

func _ready():
	anim_start()

func _process(_delta):
	if is_being_placed:
		update_pos_undermouse()

func update_pos_undermouse():
	global_position = get_global_mouse_position()
	
var anim_tween: Tween
func anim_start():
	scale = Vector2(0, 0)
	anim_tween = create_tween()
	anim_tween.set_ease(Tween.EASE_OUT)
	anim_tween.set_trans(Tween.TRANS_ELASTIC)
	anim_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.9)
	
func anim_placed():
	anim_tween = create_tween()
	anim_tween.set_ease(Tween.EASE_OUT)
	anim_tween.set_trans(Tween.TRANS_ELASTIC)
	anim_tween.tween_property(self, "scale", Vector2(1, 1), 0.9)

func place():
	is_being_placed = false
	anim_placed()
