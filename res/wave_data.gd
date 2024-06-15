class_name WaveData
extends Resource

## Data about how many of each enemy to spawn. Each EnemySpawn will generate a Timer that will 
## Spawn enemies every X seconds.
@export var enemy_spawns: Array[EnemySpawn]
## Money rewarded after all enemies dead and the wave is cleared
@export var wave_money_reward: int = 200
