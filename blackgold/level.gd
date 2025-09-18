extends Node2D

@onready var spawn_point = $SpawnPoint
var player_scene = preload("res://Player.tscn")
var current_player = null

func _ready():
	#print("Level ready")
	spawn_player()

func spawn_player():
	if not spawn_point:
		print("spawnPoint introuvable !")
		return
	if not player_scene:
		print("player_scene introuvable !")
		return

	current_player = player_scene.instantiate()
	add_child(current_player)
	print("Player instancié :", current_player)
	#print("Est-il dans l’arbre ?", current_player.is_inside_tree())
	current_player.global_position = spawn_point.global_position
