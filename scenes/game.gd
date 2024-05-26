class_name Game
extends Node2D

@onready var artstand: ArtStand = %Artstand
@onready var game_cam: Camera2D = $GameCam

func _ready():
	print('game started')
	bind_signals()

func bind_signals():
	artstand.clicked.connect(_on_artstand_clicked)

func _on_artstand_clicked():
	print('art clicked')
	game_cam.focus_on(artstand)
