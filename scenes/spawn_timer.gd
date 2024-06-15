class_name SpawnTimer
extends Timer

## Data about what enemy to spawn
@export var enemy_spawn: EnemySpawn
## the index of the wave this Timer refers to
@export var wave_index: int = 0

## How many enemies this timer has spawned
var spawned: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
