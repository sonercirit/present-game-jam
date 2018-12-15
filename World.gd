extends Node

func _ready():
	OS.set_window_maximized(true)

func _process(delta):
	var collision = $CanvasLayer/Player.get_slide_collision(0)
	if collision != null && collision.collider.is_class('KinematicBody2D'):
		collision.collider.queue_free()
	$Camera2D.move_local_x(200 * delta)
