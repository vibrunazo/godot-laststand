class_name Bullet
extends Node2D

@export var damage: float = 10
@export var speed: float = 150
@export var target: Enemy
@export var destroy_on_hit: bool = true

@onready var damage_box: DamageBox = $DamageBox

var target_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	damage_box.damage = damage
	damage_box.hit.connect(_on_damage_box_hit)
	if is_instance_valid(target):
		target_pos = target.global_position

var last_distance: float = 10000
func _process(delta):
	if is_instance_valid(target): 
		target_pos = target.global_position
		if target.has_method("get_target_pos"):
			target_pos = target.get_target_pos()
	look_at(target_pos)
	var direction = Vector2.from_angle(rotation)
	global_position += direction * speed * delta
	var distance := (target_pos - global_position).length()
	if not target and distance >= last_distance:
		queue_free()
	last_distance = distance

func _on_damage_box_hit():
	print('bullet hit')
	if destroy_on_hit:
		queue_free()


func _on_damage_box_area_entered(area: Area2D):
	if not area.get_parent() is Enemy: return
	
