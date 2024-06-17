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
## How long in seconds the next wave starts after the previous one finished spawning
@export var time_between_waves: float = 45

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
	await get_tree().create_timer(3).timeout
	start_spawner()

func start_spawner():
	start_wave()

func next_wave(wave_index: int):
	print('trying to start next wave after %s, states: %s' % [wave_index, wave_states.size()])
	if wave_states.size() > wave_index + 1:
		print('wave already started')
		return
	current_wave += 1
	start_wave()

func start_wave():
	print('starting wave %s' % [current_wave])
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
	
func on_wave_finished_spawning(wave_index: int):
	print('wave %s finished spawning all %s enemies' % [wave_index, wave_states[wave_index].max_enemies])
	await get_tree().create_timer(time_between_waves).timeout
	next_wave(wave_index)
	
func on_wave_defeated(wave_index: int):
	print('wave defeated: %s' % [wave_index])
	GameState.money += waves[wave_index].wave_money_reward
	if wave_index + 1 == num_waves:
		on_all_waves_defeated()
	else:
		await get_tree().create_timer(3).timeout
		next_wave(wave_index)

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
		on_wave_defeated(wave_index)

func _on_spawn_timer_timeout(spawner: SpawnTimer):
	var enemy_spawn: EnemySpawn = spawner.enemy_spawn
	print('timeout i: %s e: %s max: %s' % [spawner.wave_index, enemy_spawn.enemy_to_spawn, enemy_spawn.max_spawns])
	var wave_state := wave_states[spawner.wave_index]
	if spawn_by_index(enemy_spawn.enemy_to_spawn, spawner.wave_index):
		spawner.spawned += 1
		wave_states[spawner.wave_index].spawned += 1
	if spawner.spawned >= enemy_spawn.max_spawns:
		if wave_state.spawned >= wave_state.max_enemies:
			on_wave_finished_spawning(spawner.wave_index)
		spawner.queue_free()
