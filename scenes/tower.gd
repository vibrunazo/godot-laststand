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

func place():
	is_being_placed = false
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
