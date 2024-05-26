extends Node

@export var path: Path2D
@export var enemy_scene: PackedScene
@export var difficulty_curve: Curve
@export var initial_time_between_spawns: int = 5000
@export var min_time_between_spawns: int = 200
@export var max_difficulty: int = 20
## How much time between spawns is reduced each time difficulty increases
@export var time_reduction_from_difficulty: int = 300

@onready var time_between_spawns: int = initial_time_between_spawns
var last_spawn_time: int = 0
var difficulty: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func try_spawn_enemy():
	if Time.get_ticks_msec() - last_spawn_time >= time_between_spawns:
		spawn_enemy()
	update_difficulty()

func spawn_enemy():
	if not enemy_scene: return
	last_spawn_time = Time.get_ticks_msec()
	var new_enemy: Enemy = enemy_scene.instantiate() as Enemy
	path.add_child(new_enemy)

func update_difficulty():
	var time := Time.get_ticks_msec() / 1000.0
	difficulty = round(time / 10.0)
	var di: float = float(difficulty) / float(max_difficulty)
	time_between_spawns = round(difficulty_curve.sample_baked(di) * (initial_time_between_spawns - min_time_between_spawns) + min_time_between_spawns)
	time_between_spawns = clamp(time_between_spawns, min_time_between_spawns, initial_time_between_spawns)
	#print('time: %s, d: %s, tbs: %s, di: %s, c: %s' % [time, difficulty, time_between_spawns, di, difficulty_curve.sample_baked(di)])
	
func _on_spawn_timer_timeout():
	if not path: return
	try_spawn_enemy()
