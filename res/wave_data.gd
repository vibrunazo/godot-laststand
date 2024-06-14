class_name WaveData
extends Resource

@export var enemy_scene_index: int = 0

## time between spawns for the first spawn before reductions in difficulty, in seconds
@export var initial_time_between_spawns: float = 2
@export var min_time_between_spawns: float = 0.2
@export var max_difficulty: int = 20
## How much time between spawns is reduced each time difficulty increases
@export var time_reduction_from_difficulty: int = 300
@export var max_enemies: int = 5
@export var wave_money_reward: int = 200
