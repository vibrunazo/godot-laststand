extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	#UI.fullscreen_toggle.connect(_on_fullscreen_toggled)
	_on_fullscreen_toggled()
	get_viewport().size_changed.connect(_on_fullscreen_toggled)

func _on_fullscreen_toggled():
	visible = !UI.is_fullscreen()
