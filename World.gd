extends Node

func _ready():
	OS.set_window_maximized(true)

func _process(delta):
	$Camera2D.move_local_x(1)