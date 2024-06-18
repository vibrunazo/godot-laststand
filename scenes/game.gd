class_name Game
extends Node2D

@export var pick_tower_scene: PackedScene
@export var initial_health: float = 40
@export var initial_money: float = 300

@onready var artstand: ArtStand = %Artstand
@onready var game_cam: GameCam = $GameCam
@onready var ui_layer = $UILayer
@onready var tower_layer = %TowerLayer
@onready var spawner: Spawner = $Spawner
@onready var tilemap: TileMap = $TileMap

var is_selecting_tower: bool = false
var tower_menu_ref: PickTowerMenu
var tower_being_placed: Tower
var tower_data_being_placed: TowerData
var is_ready: bool = false
## Map of cell coords per tower placed
## Key: Vector2i cell coord
## Value: Tower ref to the placed tower
var map_tower_per_cell: Dictionary

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
	if tower_data_being_placed.cost > GameState.money:
		not_enought_money()
		return
	if not can_place_here(tower_being_placed.global_position):
		cancel_tower_placing()
		return
	var cell_pos := get_cell_coord_from_global(tower_being_placed.global_position)
	map_tower_per_cell[cell_pos] = tower_being_placed
	tower_being_placed.global_position = get_center_of_tile_under_mouse()
	tower_being_placed.modulate = Color.WHITE
	tower_being_placed.place()
	tower_being_placed = null
	GameState.money -= tower_data_being_placed.cost

func not_enought_money():
	print('not enough money')
	cancel_tower_placing()
	
func spawn_tower(tower_data: TowerData):
	if not tower_data: return
	cancel_tower_placing()
	var tower_scene: PackedScene = tower_data.scene
	var tower: Tower = tower_scene.instantiate() as Tower
	tower_layer.add_child(tower)
	tower_being_placed = tower
	tower_data_being_placed = tower_data

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

## Returns the cell coord of a given global coordinate
func get_cell_coord_from_global(from: Vector2) -> Vector2i:
	return tilemap.local_to_map(from)

## Returns whether it's possible to place a tower here. False if not wall or there's an existing Tower
func can_place_here(pos: Vector2) -> bool:
	var is_wall: bool = is_wall_at(pos)
	if not is_wall: return false
	var cell_pos: = get_cell_coord_from_global(tower_being_placed.global_position)
	if not map_tower_per_cell.has(cell_pos): return true
	var existing_tower: Tower = map_tower_per_cell[cell_pos]
	if is_instance_valid(existing_tower):
		return false
	return true

## Returns whether given global pos is a wall or not
func is_wall_at(pos: Vector2) -> bool:
	var clicked_cell = tilemap.local_to_map(pos)
	var data = tilemap.get_cell_tile_data(0, clicked_cell)
	if data:
		return data.get_custom_data("wall")
	else:
		return false
		
## Returns whether the tile under mouse is a wall or not
func get_clicked_tile_wall() -> bool:
	return is_wall_at(tilemap.get_local_mouse_position())

## Returns the global position of the center of the tile that is under the mouse
func get_center_of_tile_under_mouse() -> Vector2:
	var clicked_cell = tilemap.local_to_map(tilemap.get_local_mouse_position())
	var local := tilemap.map_to_local(clicked_cell)
	var global := tilemap.to_global(local)
	return global

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var is_wall: bool = get_clicked_tile_wall()
		
		if is_selecting_tower:
			_on_artstand_clicked()
		elif is_instance_valid(tower_being_placed):
			if is_wall:
				place_tower()
	elif event is InputEventMouseMotion and is_instance_valid(tower_being_placed):
		var can_place: bool = can_place_here(get_global_mouse_position())
		tower_being_placed.global_position = get_center_of_tile_under_mouse()
		if can_place:
			tower_being_placed.modulate = Color.WHITE
		else:
			tower_being_placed.modulate = Color.RED

func _unhandled_key_input(event):
	if event.is_action("ui_left"):
		game_cam.input_dir(Vector2.LEFT)
	if event.is_action("ui_right"):
		game_cam.input_dir(Vector2.RIGHT)
	if event.is_action("ui_up"):
		game_cam.input_dir(Vector2.UP)
	if event.is_action("ui_down"):
		game_cam.input_dir(Vector2.DOWN)
				
			
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
	if tower_data.cost > GameState.money:
		not_enought_money()
		return
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
