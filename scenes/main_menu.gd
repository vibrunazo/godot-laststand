extends CanvasLayer

@onready var anim = $Anim

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	await get_tree().create_timer(1).timeout
	anim.play("start")