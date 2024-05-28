class_name Enemy
extends PathFollow2D

@export var speed_min: float = 100.0
@export var speed_max: float = 200.0
@export var offset_max: float = 10.0

@export var max_health: float = 50.0

@onready var sprite: Sprite2D = $Sprite
@onready var target_pos: Node2D = $TargetPos

var SPEED: = 100.0
var health: float = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED = randf_range(speed_min, speed_max)
	h_offset += randf_range(-offset_max, offset_max)
	v_offset += randf_range(-offset_max, offset_max)
	health = max_health
	
func get_hit(damage: float):
	health -= damage
	health = clamp(health, 0, max_health)
	if health == 0:
		queue_free()
	else:
		anim_gethit()

func anim_gethit():
	var ini_pos: Vector2 = sprite.position
	modulate = Color.RED
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "position", ini_pos + Vector2.LEFT * 16, 0.02)
	tween.tween_property(sprite, "position", ini_pos + Vector2.RIGHT * 10, 0.02)
	tween.tween_property(sprite, "position", ini_pos + Vector2.LEFT * 10, 0.02)
	tween.tween_property(sprite, "position", ini_pos + Vector2.RIGHT * 10, 0.02)
	tween.tween_property(sprite, "position", ini_pos, 0.05)
	tween.tween_property(self, "modulate", Color.WHITE, 0.075)

## Returns the global position bullets will aim for
func get_target_pos() -> Vector2:
	if not is_instance_valid(target_pos): return global_position
	return target_pos.global_position
		


func _physics_process(delta):
	progress += delta * SPEED

func _process(_delta):
	sprite.global_rotation_degrees = 0
	if abs(rotation_degrees) > 90:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
