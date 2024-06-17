@icon("res://assets/tex/canvas.png")
class_name Tower
extends Node2D

@export var damage: float = 10
@export var bullet_scene: PackedScene

@onready var attack_timer = $AttackTimer
@onready var audio_placed = $AudioPlaced
@onready var audio_fire = $AudioFire
@onready var anim = $Anim
@onready var spawn_pos = $SpawnPos
@onready var sprite_canvas = $Sprite2D

var is_being_placed: bool = true
var aggro_list: Array[Enemy]


func _ready():
	anim_start()

func try_attack():
	if aggro_list.is_empty(): return
	if is_being_placed: return
	attack();

func attack():
	var target: Enemy = pick_target_from_aggro_list()
	#target.get_hit(damage)
	if not target.is_ready: return
	anim_shoot(target)
	spawn_bullet(target)

func pick_target_from_aggro_list() -> Enemy:
	var target: Enemy = aggro_list[0]
	var score = 0
	for enemy in aggro_list:
		if not enemy.is_ready: continue
		if enemy.progress_ratio > score:
			target = enemy
			score = enemy.progress_ratio
	return target

func spawn_bullet(target: Enemy):
	if not bullet_scene: return
	var tower_layer = get_tree().get_first_node_in_group("tower_layer")
	if not tower_layer: return
	var bullet: Bullet = bullet_scene.instantiate() as Bullet
	bullet.damage = damage
	bullet.target = target
	bullet.caster = self
	bullet.global_position = global_position
	tower_layer.call_deferred("add_child", bullet)
	audio_fire.play()
	
	

func update_pos_undermouse():
	global_position = get_global_mouse_position()
	
var anim_tween: Tween
func anim_start():
	scale = Vector2(0, 0)
	anim_tween = create_tween()
	anim_tween.set_ease(Tween.EASE_OUT)
	anim_tween.set_trans(Tween.TRANS_ELASTIC)
	anim_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.9)
	
func anim_placed():
	audio_placed.play()
	anim_tween = create_tween()
	anim_tween.set_ease(Tween.EASE_OUT)
	anim_tween.set_trans(Tween.TRANS_ELASTIC)
	anim_tween.tween_property(self, "scale", Vector2(1, 1), 0.9)

@onready var ini_canvas_pos: Vector2
@onready var ini_canvas_scale: Vector2
func anim_shoot(target: Enemy):
	var dir: Vector2 = (target.global_position - sprite_canvas.global_position).normalized()
	var recoil_pos = sprite_canvas.global_position - dir * 30
	var target_scale := Vector2(randf_range(0.8, 1.1), randf_range(0.8, 1.1))
	anim_tween = create_tween()
	anim_tween.set_parallel(true)
	anim_tween.set_ease(Tween.EASE_OUT)
	anim_tween.set_trans(Tween.TRANS_QUAD)
	anim_tween.tween_property(sprite_canvas, "global_position", recoil_pos, 0.08)
	anim_tween.tween_property(sprite_canvas, "scale", ini_canvas_scale * target_scale, 0.08)
	anim_tween.set_parallel(false)
	anim_tween.set_ease(Tween.EASE_IN_OUT)
	anim_tween.set_trans(Tween.TRANS_QUAD)
	anim_tween.tween_property(sprite_canvas, "global_position", ini_canvas_pos, 0.8)
	anim_tween.set_parallel(true)
	anim_tween.tween_property(sprite_canvas, "scale", ini_canvas_scale , 0.8)

func place():
	is_being_placed = false
	ini_canvas_pos = sprite_canvas.global_position
	ini_canvas_scale = sprite_canvas.scale
	anim_placed()
	if not aggro_list.is_empty():
		attack_timer.start()
		try_attack()
	

func _on_aggro_area_area_entered(area):
	if not area.get_parent() is Enemy: return
	if not area.get_parent().is_ready: return
	aggro_list.append(area.get_parent())
	if not is_being_placed and attack_timer.is_stopped():
		attack_timer.start()
		try_attack()

func _on_aggro_area_area_exited(area: Area2D):
	var enemy := area.get_parent()
	if not enemy is Enemy: return
	aggro_list.erase(enemy)


func _on_attack_timer_timeout():
	if aggro_list.is_empty():
		attack_timer.stop()
		return
	try_attack()
