extends PathFollow2D

@export var SPEED = 100.0
@onready var sprite = $Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	progress += delta * SPEED

func _process(_delta):
	sprite.global_rotation_degrees = 0
	if abs(rotation_degrees) > 90:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
