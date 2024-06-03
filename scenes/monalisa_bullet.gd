extends Bullet

## Speed it moves when backing to canvas after grabbing
@export var backing_speed: float = 200

var is_grabbing: bool = false
var is_eating: bool = false
var ini_pos: Vector2
var grab_target: Enemy


func _ready():
	ini_pos = global_position
	if is_instance_valid(caster):
		ini_pos = caster.spawn_pos.global_position
	super()

func _physics_process(delta):
	super(delta)
	if not is_grabbing: return
	direction = (ini_pos - global_position).normalized()
	var distance := (ini_pos - global_position).length()
	global_position += direction * backing_speed * delta
	if is_instance_valid(grab_target):
		grab_target.global_position = global_position
		if is_eating:
			global_position = caster.spawn_pos.global_position
			grab_target.global_scale = caster.spawn_pos.global_scale
			grab_target.global_rotation = caster.spawn_pos.global_rotation
			global_rotation_degrees = -80
	if distance >= last_distance:
		eat()
	last_distance = distance

func eat():
	if is_eating: return
	is_eating = true
	caster.anim.play("eat")
	await get_tree().create_timer(1.2).timeout
	if is_instance_valid(grab_target):
		grab_target.die()
	
	queue_free()
	

func pick_what_to_follow() -> FOLLOW:
	if not is_grabbing: return super()
	return FOLLOW.NONE
#
func _on_damage_box_hit(target_enemy: Enemy):
	is_grabbing = true
	is_ready = false
	damage_box.is_ready = false
	last_distance = 10000
	grab_target = target_enemy
	grab_target.grab()
	super(target_enemy)
