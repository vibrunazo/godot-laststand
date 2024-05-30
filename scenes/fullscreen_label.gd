extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	UI.fullscreen_toggle.connect(_on_fullscreen_toggled)
	_on_fullscreen_toggled(UI.is_fullscreen())

func _on_fullscreen_toggled(state: bool):
	visible = !state