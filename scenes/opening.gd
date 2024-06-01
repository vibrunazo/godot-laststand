extends Control

@onready var anim = $Anim

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout
	if OS.get_name() == "Web":
		UI.go_fullscreen()
	await get_tree().create_timer(1).timeout
	anim.play("raid")
	anim.animation_finished.connect(_on_finished)

func _on_finished(anim_name: String):
	match anim_name:
		"raid":
			anim.play("jobless")
		"jobless":
			anim.play("aigen")
		"aigen":
			UI.go_to_main_menu()
