class_name Bullet
extends Node2D

@export var damage: float = 10
@export var speed: float = 150
@export var target: Enemy
@export var destroy_on_hit: bool = true

@onready var damage_box: DamageBox = $DamageBox
@onready var sprite_root = $SpriteRoot

var target_pos: Vector2
var ignore_id: String
var id: int

# Called when the node enters the scene tree for the first time.
func _ready():
	id = Bullet.get_id()
	damage_box.damage = damage
	if ignore_id.is_empty(): damage_box.ignore_id = "%d"%id
	else: damage_box.ignore_id = ignore_id
	damage_box.hit.connect(_on_damage_box_hit)
	if is_instance_valid(target):
		target_pos = target.global_position
	if target_pos.x < global_position.x:
		sprite_root.scale.y = -1

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
	if destroy_on_hit:
		queue_free()


func _on_damage_box_area_entered(area: Area2D):
	if not area.get_parent() is Enemy: return

static var last_id: int = 0
static func get_id() -> int:
	last_id += 1
	return last_id
