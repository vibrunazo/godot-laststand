extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.money_changed.connect(_on_money_changed)


func _on_money_changed(new_value: float):
	text = "%s" % round(new_value)
