class_name Bullet
extends Node2D

@export var damage: float = 10
@export var speed: float = 250
@export var target: Node2D

@onready var damage_box: DamageBox = $DamageBox


# Called when the node enters the scene tree for the first time.
func _ready():
	#damage_box = $DamageBox
	#await get_tree().process_frame
	damage_box.damage = damage
	damage_box.hit.connect(_on_damage_box_hit)

func _process(delta):
	if not target: 
		queue_free()
		return
	look_at(target.global_position)
	var direction = Vector2.from_angle(rotation)
	global_position += direction * speed * delta

func _on_damage_box_hit():
	queue_free()


func _on_damage_box_area_entered(area: Area2D):
	if not area.get_parent() is Enemy: return
	
