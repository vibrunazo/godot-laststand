class_name Game
extends Node2D

@export var pick_tower_scene: PackedScene
@export var initial_health: float = 20
@export var initial_money: float = 200

@onready var artstand: ArtStand = %Artstand
@onready var game_cam: GameCam = $GameCam
@onready var ui_layer = $UILayer
@onready var tower_layer = $TowerLayer
@onready var spawner: Spawner = $Spawner

var is_selecting_tower: bool = false
var tower_menu_ref: PickTowerMenu
var tower_being_placed: Tower
var is_ready: bool = false

func _ready():
	print('game started')
	bind_signals()
	start_game()

func start_game():
	GameState.max_health = initial_health
	GameState.health = initial_health
	GameState.money = initial_money
	is_ready = true
	GameState.is_playing = true
	Events.game_start.emit()

func bind_signals():
	artstand.clicked.connect(_on_artstand_clicked)
	Events.goal_damaged.connect(_on_goal_damaged)
	spawner.spawner_defeated.connect(_on_spawner_defeated)
	
func show_pick_tower_menu():
	if not is_selecting_tower: return
	if not pick_tower_scene: return
	cancel_tower_placing()
	if is_instance_valid(tower_menu_ref):
		tower_menu_ref.queue_free()
	tower_menu_ref = pick_tower_scene.instantiate() as PickTowerMenu
	ui_layer.add_child(tower_menu_ref)
	tower_menu_ref.button_pressed.connect(_on_tower_button_pressed)

func hide_pick_tower_menu():
	game_cam.zoom_out()
	if not is_instance_valid(tower_menu_ref): return
	tower_menu_ref.anim_end()

func cancel_tower_placing():
	if is_instance_valid(tower_being_placed):
		tower_being_placed.queue_free()
		tower_being_placed = null

func place_tower():
	if not is_instance_valid(tower_being_placed): return
	tower_being_placed.place()
	tower_being_placed = null
	
func spawn_tower(tower_data: TowerData):
	if not tower_data: return
	cancel_tower_placing()
	var tower_scene: PackedScene = tower_data.scene
	var tower: Tower = tower_scene.instantiate() as Tower
	tower_layer.add_child(tower)
	tower_being_placed = tower

func game_over():
	is_ready = false
	if is_selecting_tower: _on_artstand_clicked()
	GameState.is_playing = false
	UI.show_game_over()

func win():
	if is_selecting_tower: _on_artstand_clicked()
	is_ready = false
	GameState.is_playing = false
	await get_tree().create_timer(2).timeout
	UI.show_win()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if is_selecting_tower:
			_on_artstand_clicked()
		elif is_instance_valid(tower_being_placed):
			place_tower()
			
func _on_artstand_clicked():
	is_selecting_tower = !is_selecting_tower
	cancel_tower_placing()
	if is_selecting_tower: 
		game_cam.focus_on(artstand)
		await game_cam.zoom_finished
		show_pick_tower_menu()
	else: 
		hide_pick_tower_menu()

func _on_tower_button_pressed(button: PickTowerButton):
	var tower_data: TowerData = button.tower_data
	await get_tree().create_timer(0.4).timeout
	_on_artstand_clicked()
	await get_tree().create_timer(0.2).timeout
	spawn_tower(tower_data)

func _on_goal_damaged(damage: float):
	if not is_instance_valid(artstand) or not is_ready:
		return
	var new_health: float = GameState.health
	new_health -= damage
	new_health = clamp(new_health, 0, initial_health)
	GameState.health = new_health
	if GameState.health == 0:
		artstand.die()
		game_over()
		return
	artstand.get_hit()

## when all enemies spawned by a spawner have been defeated
func _on_spawner_defeated(_spawner):
	if GameState.health > 0 and GameState.is_playing:
		win()
