class_name DamageBox
extends Area2D

@export var damage: float = 10

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_area_entered(area: Area2D):
	if not area.get_parent() is Enemy: return
	var enemy: Enemy = area.get_parent() as Enemy
	enemy.get_hit(damage)
	hit.emit()
