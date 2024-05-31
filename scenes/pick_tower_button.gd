class_name PickTowerButton
extends Button

@export var tower_data: TowerData
@onready var label_name = %LabelName
@onready var label_cost = %LabelCost

func _ready():
	update_from_data()

func update_from_data():
	label_name.text = tower_data.name
	label_cost.text = "$%s" % round(tower_data.cost)

var click_tween: Tween
func anim_click():
	click_tween = create_tween()
	click_tween.set_ease(Tween.EASE_IN_OUT)
	click_tween.set_trans(Tween.TRANS_QUAD)
	click_tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	click_tween.set_ease(Tween.EASE_OUT)
	click_tween.set_trans(Tween.TRANS_ELASTIC)
	click_tween.tween_property(self, "scale", Vector2(1, 1), 0.4)

func anim_fade_out():
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.4)
	

func _on_button_down():
	anim_click()
