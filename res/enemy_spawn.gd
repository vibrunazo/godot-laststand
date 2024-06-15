class_name EnemySpawn
extends Resource

## Index of the Enemy to spawn, Spawner picks a PackedScene from this index
@export var enemy_to_spawn: int = 0
## How many enemies to spawn
@export var max_spawns: int = 10
## Timer between spawns, spawns one enemy every X seconds
@export var spawn_timer: float = 1.5
