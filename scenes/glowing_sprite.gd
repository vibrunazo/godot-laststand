extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	start_glow()

func start_glow():
	var tween: Tween = create_tween()
	tween.set_loops()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.6)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
