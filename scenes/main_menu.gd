extends CanvasLayer

@onready var anim = $Anim

# Called when the node enters the scene tree for the first time.
func _ready():
	#await get_tree().create_timer(1).timeout
	anim.play("start")

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		anim.play("skip")

