class_name Enemy
extends PathFollow2D

@export var speed_min: float = 100.0
@export var speed_max: float = 200.0
@export var offset_max: float = 10.0
@export var max_health: float = 80.0
## How much money I give on death
@export var money_on_death: float = 2
## How much money I give per health point taken in damage
@export var money_per_hit: float = 0.1

@onready var sprite: Sprite2D = $Sprite
@onready var target_pos: Node2D = $TargetPos
@onready var audio_gethit = $AudioGethit

var SPEED: = 100.0
var health: float = 100
var ignore_ids: Array[String]
var last_pos: Vector2 
var is_ready: bool = true

signal killed

# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED = randf_range(speed_min, speed_max)
	h_offset += randf_range(-offset_max, offset_max)
	v_offset += randf_range(-offset_max, offset_max)
	health = max_health
	last_pos = global_position
	
	
func get_hit(damage: float):
	if not is_ready: return
	var health_before: float = health
	health -= damage
	health = clamp(health, 0, max_health)
	var health_delta = health_before - health
	GameState.money += health_delta * money_per_hit
	if health == 0:
		audio_gethit.detach_and_play()
		die()
	else:
		audio_gethit.play()
		anim_gethit()
		

func die():
	is_ready = false
	GameState.money += money_on_death
	killed.emit()
	queue_free()

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
	killed.emit()
	queue_free()

func _physics_process(delta):
	progress += delta * SPEED
	if progress_ratio >= 1:
		reach_end()
		return
	update_sprite_flip()
	last_pos = global_position
