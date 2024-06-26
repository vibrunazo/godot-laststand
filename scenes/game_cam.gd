class_name GameCam
extends Camera2D

## Time the zoom out tween takes in seconds
@export var zoom_out_speed: float = 0.6
## Time the zoom in tween takes in seconds
@export var zoom_in_speed: float = 0.3

## default zoom to reset to on zoom out
var ini_zoom: Vector2
## default global_position to reset to on zoom out
var ini_pos: Vector2

var is_zoomed_in: bool = false

signal zoom_finished

func _ready():
	setup_camera()

func setup_camera():
	ini_pos = global_position
	ini_zoom = zoom

func toggle_zoom(target_node: Node2D):
	if is_zoomed_in: zoom_out()
	else: focus_on(target_node)

var zoom_tween: Tween
func focus_on(target_node: Node2D):
	ini_pos = global_position
	zoom_to(target_node.global_position, Vector2(1,1), zoom_in_speed)
	is_zoomed_in = true

func zoom_to(target_pos: Vector2, target_zoom: Vector2, tween_time: float = 0.5):
	zoom_tween = create_tween()
	zoom_tween.set_parallel(true)
	zoom_tween.set_ease(Tween.EASE_IN_OUT)
	zoom_tween.set_trans(Tween.TRANS_QUAD)
	zoom_tween.tween_property(self, "zoom", target_zoom, tween_time)
	zoom_tween.tween_property(self, "global_position", target_pos, tween_time)
	zoom_tween.set_parallel(false)
	zoom_tween.tween_callback(_on_zoom_finished)

func _on_zoom_finished():
	zoom_finished.emit()

func zoom_out():
	zoom_to(ini_pos, ini_zoom, zoom_out_speed)
	is_zoomed_in = false

func input_dir(dir: Vector2):
	global_position += dir * 1000 * get_process_delta_time() 
