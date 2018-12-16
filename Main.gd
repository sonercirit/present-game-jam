extends Node

export (PackedScene) var game_scene

func _ready():
	pass

func _on_Start_pressed():
	$Start.hide()
	add_child(game_scene.instance())
