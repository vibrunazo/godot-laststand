extends CanvasLayer

@onready var root: Control = $Root

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_fade_in()

func anim_fade_in():
	root.modulate = Color.TRANSPARENT 
	var tween: Tween = create_tween()
	tween.tween_property(root, "modulate", Color.WHITE, 1)
