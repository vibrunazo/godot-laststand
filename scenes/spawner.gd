class_name Spawner
extends Node

@export var path: Path2D
@export var enemy_scene: PackedScene
@export var enemy_big_scene: PackedScene
@export var difficulty_curve: Curve
@export var initial_time_between_spawns: float = 5
@export var min_time_between_spawns: float = 0.2
@export var max_difficulty: int = 20
## How much time between spawns is reduced each time difficulty increases
@export var time_reduction_from_difficulty: int = 300
@export var max_enemies: int = 5
@export var wave_money_reward: int = 200

## Maximum number of waves to spawn
@export var waves: int = 5
## Which wave to start in by index
@export var starting_wave: int = 0
## The wave currently spawning
var current_wave: int = 0
@onready var spawn_timer: Timer = $SpawnTimer
@onready var time_between_spawns: float = initial_time_between_spawns

## emitted when all enemies of one wave have been defeated
signal wave_defeated()
## emitted when all spawned enemies have been killed
signal spawner_defeated(spawner: Spawner)

var last_spawn_time: float = 0
var difficulty: int = 0
var num_spawned: int = 0
var num_killed: int = 0
## Time since this spawner started in seconds
var time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.game_over.connect(_on_game_over)
	current_wave = starting_wave
	start_spawner()

func start_spawner():
	difficulty = 0
	num_spawned = 0
	num_killed = 0
	spawn_timer.start()
	
func try_spawn_enemy():
	if num_spawned >= max_enemies and max_enemies > 0:
		return
	if time - last_spawn_time >= time_between_spawns:
		spawn_enemy()
	update_difficulty()

func spawn_enemy():
	if not enemy_scene: return
	last_spawn_time = time
	var new_enemy: Enemy = pick_enemy_to_spawn()
	new_enemy.killed.connect(_on_enemy_killed)
	path.add_child(new_enemy)
	num_spawned += 1

func pick_enemy_to_spawn() -> Enemy:
	if difficulty <= 7: 
		#print('d: %s <= 5' % difficulty)
		return enemy_scene.instantiate()
	var r = randf()
	var t = float(difficulty) / float(max_difficulty)
	t *= 0.2
	var b = r < t
	#print('d: %s, r: %s, t: %s, b: %s' % [difficulty, r, t, b])
	if b: return enemy_big_scene.instantiate()
	
	return enemy_scene.instantiate()

func update_difficulty():
	#var time := time / 1000.0
	difficulty = round(time / 10.0)
	var di: float = float(difficulty) / float(max_difficulty)
	time_between_spawns = round(difficulty_curve.sample_baked(di) * (initial_time_between_spawns - min_time_between_spawns) + min_time_between_spawns)
	time_between_spawns = clamp(time_between_spawns, min_time_between_spawns, initial_time_between_spawns)
	#print('time: %s, d: %s, tbs: %s, di: %s, c: %s' % [time, difficulty, time_between_spawns, di, difficulty_curve.sample_baked(di)])

func on_wave_defeated():
	print('wave defeated: %s' % [current_wave])
	GameState.money += wave_money_reward
	spawn_timer.stop() 
	current_wave += 1
	if current_wave == waves:
		on_all_waves_defeated()
	else:
		await get_tree().create_timer(2).timeout
		start_spawner()

func on_all_waves_defeated():
	print('all waves defeated')
	spawner_defeated.emit(self)
	queue_free()

func _on_spawn_timer_timeout():
	if not path: return
	time += spawn_timer.wait_time
	try_spawn_enemy()

func _on_game_over():
	queue_free()

func _on_enemy_killed():
	num_killed += 1
	if num_killed >= max_enemies and max_enemies > 0:
		on_wave_defeated()
