class_name Spawner
extends Node

@export var path: Path2D
@export var difficulty_curve: Curve
@export var waves: Array[WaveData]
#@export var enemy_scene: PackedScene
#@export var enemy_big_scene: PackedScene
@export var enemy_scenes: Array[PackedScene]
## Maximum number of waves to spawn
@export var num_waves: int = 5
## Which wave to start in by index
@export var starting_wave: int = 0

## emitted when all enemies of one wave have been defeated
signal wave_defeated()
## emitted when all spawned enemies have been killed
signal spawner_defeated(spawner: Spawner)

## The wave currently spawning
var current_wave: int = 0

var wave_states: Array[WaveState]

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.game_over.connect(_on_game_over)
	num_waves = waves.size()
	if starting_wave < num_waves:
		current_wave = starting_wave
	await get_tree().create_timer(1).timeout
	start_spawner()

func start_spawner():
	start_wave()

func start_wave():
	build_wave_timers()

func build_wave_timers():
	if current_wave >= num_waves:
		return
	var new_wave_state: WaveState = WaveState.new()
	wave_states.append(new_wave_state)
	for enemy_spawn: EnemySpawn in waves[current_wave].enemy_spawns:
		wave_states[current_wave].max_enemies += enemy_spawn.max_spawns
		var new_timer: SpawnTimer = SpawnTimer.new()
		new_timer.enemy_spawn = enemy_spawn
		new_timer.wave_index = current_wave
		add_child(new_timer)
		new_timer.start(enemy_spawn.spawn_timer)
		new_timer.timeout.connect(_on_spawn_timer_timeout.bind(new_timer))

func spawn_by_index(enemy_index: int, wave_index: int) -> bool:
	if enemy_index >= enemy_scenes.size(): return false
	var enemy_scene: PackedScene = enemy_scenes[enemy_index]
	if not enemy_scene: return false
	var new_enemy: Enemy = enemy_scene.instantiate() as Enemy
	new_enemy.killed.connect(_on_enemy_killed.bind(wave_index))
	path.add_child(new_enemy)
	return true
	
func on_wave_defeated():
	print('wave defeated: %s' % [current_wave])
	GameState.money += waves[current_wave].wave_money_reward
	current_wave += 1
	if current_wave == num_waves:
		on_all_waves_defeated()
	else:
		await get_tree().create_timer(2).timeout
		start_wave()

func on_all_waves_defeated():
	print('all waves defeated')
	spawner_defeated.emit(self)
	queue_free()


func _on_game_over():
	queue_free()

func _on_enemy_killed(wave_index: int):
	var wave_state: WaveState = wave_states[wave_index]
	wave_state.killed += 1
	if wave_state.killed >= wave_state.max_enemies and wave_state.max_enemies > 0:
		on_wave_defeated()

func _on_spawn_timer_timeout(spawner: SpawnTimer):
	var enemy_spawn: EnemySpawn = spawner.enemy_spawn
	print('timeout e: %s max: %s' % [enemy_spawn.enemy_to_spawn, enemy_spawn.max_spawns])
	if spawn_by_index(enemy_spawn.enemy_to_spawn, spawner.wave_index):
		spawner.spawned += 1
	if spawner.spawned >= enemy_spawn.max_spawns:
		spawner.queue_free()
