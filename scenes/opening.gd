extends Control

@onready var anim = $Anim

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout
	anim.play("start")
	anim.animation_finished.connect(_on_finished)

func _on_finished(_anim_name: String):
	UI.go_to_main_menu()
