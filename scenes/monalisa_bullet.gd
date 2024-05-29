extends Bullet

## Speed it moves when backing to canvas after grabbing
@export var backing_speed: float = 200

var is_grabbing: bool = false
var ini_pos: Vector2


func _ready():
	ini_pos = global_position
	super()

func _physics_process(delta):
	super(delta)
	if not is_grabbing: return
	direction = (ini_pos - global_position).normalized()
	var distance := (ini_pos - global_position).length()
	global_position += direction * backing_speed * delta
	if distance >= last_distance:
		eat()
	last_distance = distance

func eat():
	queue_free()
	

func pick_what_to_follow() -> FOLLOW:
	if not is_grabbing: return super()
	return FOLLOW.NONE
#
func _on_damage_box_hit(_target_enemy: Enemy):
	is_grabbing = true
	is_ready = false
	damage_box.is_ready = false
	last_distance = 10000
	super(_target_enemy)
