class_name Enemy
extends PathFollow2D

@export var speed_min: float = 1000.0
@export var speed_max: float = 2000.0
@export var offset_max: float = 10.0

@export var max_health: float = 50.0

@onready var sprite: Sprite2D = $Sprite
@onready var target_pos: Node2D = $TargetPos

var SPEED: = 100.0
var health: float = 50
var ignore_ids: Array[String]
var last_pos: Vector2 
var is_ready: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED = randf_range(speed_min, speed_max)
	h_offset += randf_range(-offset_max, offset_max)
	v_offset += randf_range(-offset_max, offset_max)
	health = max_health
	last_pos = global_position
	
	
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
		
func update_sprite_flip():
	var direction: Vector2 = global_position - last_pos
	var angle: float = direction.angle() * 180 / PI
	if abs(angle) > 110:
		sprite.flip_h = true
	elif abs(angle) < 70:
		sprite.flip_h = false

func reach_end():
	is_ready = false
	Events.goal_damaged.emit(1)
	queue_free()

func _physics_process(delta):
	progress += delta * SPEED
	if progress_ratio >= 1:
		reach_end()
		return
	update_sprite_flip()
	last_pos = global_position
