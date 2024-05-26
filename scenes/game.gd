class_name Game
extends Node2D

@export var pick_tower_scene: PackedScene

@onready var artstand: ArtStand = %Artstand
@onready var game_cam: GameCam = $GameCam
@onready var ui_layer = $UILayer

var is_selecting_tower: bool = false
var tower_menu_ref: PickTowerMenu

func _ready():
	print('game started')
	bind_signals()

func bind_signals():
	artstand.clicked.connect(_on_artstand_clicked)
	
func show_pick_tower_menu():
	if not pick_tower_scene: return
	if is_instance_valid(tower_menu_ref):
		tower_menu_ref.queue_free()
	tower_menu_ref = pick_tower_scene.instantiate() as PickTowerMenu
	ui_layer.add_child(tower_menu_ref)

func hide_pick_tower_menu():
	game_cam.zoom_out()
	if not is_instance_valid(tower_menu_ref): return
	tower_menu_ref.anim_end()

func _on_artstand_clicked():
	is_selecting_tower = !is_selecting_tower
	if is_selecting_tower: 
		game_cam.focus_on(artstand)
		await game_cam.zoom_finished
		show_pick_tower_menu()
	else: 
		hide_pick_tower_menu()
		
func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if is_selecting_tower:
			_on_artstand_clicked()
