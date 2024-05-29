class_name Bullet
extends Node2D

@export var damage: float = 10
@export var speed: float = 150
@export var target: Enemy
@export var destroy_on_hit: bool = true

@onready var damage_box: DamageBox = $DamageBox
@onready var sprite_root = $SpriteRoot

var target_pos: Vector2
var direction: Vector2
var last_direction: Vector2
var last_distance: float = 10000
var ignore_id: String
var id: int
## Whether I'm ready to hit a target
var is_ready: bool = true
var what_to_follow: FOLLOW = FOLLOW.TARGET
enum FOLLOW {
	TARGET, ## Follow the target Enemy
	POS, ## Follow the last known target position
	DIR, ## Keep going in current direction
	NONE ## Do not follow
}

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

func _physics_process(delta):
	what_to_follow = pick_what_to_follow()
	match what_to_follow as FOLLOW:
		FOLLOW.TARGET:
			target_pos = target.global_position
			if target.has_method("get_target_pos"):
				target_pos = target.get_target_pos()
			follow_target_pos(delta)
		FOLLOW.POS:
			follow_target_pos(delta)
		FOLLOW.DIR:
			move_in_last_dir(delta)
	

func follow_target_pos(delta: float):
	look_at(target_pos)
	direction = Vector2.from_angle(rotation)
	global_position += direction * speed * delta
	var distance := (target_pos - global_position).length()
	if not target and distance >= last_distance:
		# HACK: more elegant solution might be to predict instead of undo
		global_position -= direction * speed * delta
		direction = last_direction
		rotation = last_direction.angle()
		global_position += direction * speed * delta
		whiff()
		return
	last_distance = distance
	last_direction = direction

func move_in_last_dir(delta):
	global_position += direction * speed * delta

func pick_what_to_follow() -> FOLLOW:
	if not is_ready: return FOLLOW.DIR
	if is_instance_valid(target):
		return FOLLOW.TARGET
	return FOLLOW.POS

## Attack missed, play whiff anim
func whiff():
	is_ready = false
	damage_box.is_ready = false
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	tween.tween_callback(queue_free)
	#queue_free()

func _on_damage_box_hit(_target_enemy: Enemy):
	if destroy_on_hit:
		queue_free()


func _on_damage_box_area_entered(area: Area2D):
	if not area.get_parent() is Enemy: return

static var last_id: int = 0
static func get_id() -> int:
	last_id += 1
	return last_id
