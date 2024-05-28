class_name DamageBox
extends Area2D

@export var damage: float = 10
@export var ignore_id: String

var is_ready: bool = true
signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_area_entered(area: Area2D):
	if not is_ready: return
	if not area.get_parent() is Enemy: return
	var enemy: Enemy = area.get_parent() as Enemy
	if enemy.ignore_ids.has(ignore_id): return
	enemy.get_hit(damage)
	if not ignore_id.is_empty():
		enemy.ignore_ids.append(ignore_id)
	hit.emit()
