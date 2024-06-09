class_name ArtStand
extends Sprite2D

signal clicked
@onready var sprite: Sprite2D = $Canvas
@onready var health_bar = %HealthBar
@onready var audio_click = $AudioClick
@onready var button = $Button


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.health_changed.connect(_on_health_changed)
	button.grab_focus()
	button.pressed.connect(_on_button_down)
	
	
var click_tween: Tween
func anim_click():
	audio_click.play()
	click_tween = create_tween()
	click_tween.set_ease(Tween.EASE_IN_OUT)
	click_tween.set_trans(Tween.TRANS_QUAD)
	click_tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	click_tween.set_ease(Tween.EASE_OUT)
	click_tween.set_trans(Tween.TRANS_ELASTIC)
	click_tween.tween_property(self, "scale", Vector2(1, 1), 0.4)

func get_hit():
	anim_gethit()

func die():
	queue_free()

func update_healthbar():
	health_bar.max_value = GameState.max_health
	health_bar.value = GameState.health

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

func _on_health_changed(new_value: float):
	print('health changed on artstand to %s' % [new_value])
	update_healthbar()
