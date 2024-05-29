class_name ArtStand
extends Sprite2D

signal clicked
@onready var sprite: Sprite2D = $Canvas


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

func get_hit():
	anim_gethit()

func anim_gethit():
	var ini_pos: Vector2 = position
	modulate = Color.RED
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", ini_pos + Vector2.LEFT * 20, 0.02)
	tween.tween_property(self, "position", ini_pos + Vector2.RIGHT * 16, 0.02)
	tween.tween_property(self, "position", ini_pos + Vector2.LEFT * 16, 0.02)
	tween.tween_property(self, "position", ini_pos + Vector2.RIGHT * 16, 0.02)
	tween.tween_property(self, "position", ini_pos, 0.05)
	tween.tween_property(self, "modulate", Color.WHITE, 0.075)

func _on_button_down():
	clicked.emit()
	anim_click()
