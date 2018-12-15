extends Node

export (PackedScene) var Ball
var total_delta = 0
var screensize = Vector2()

func _ready():
	OS.set_window_maximized(true)
	screensize = get_viewport().size

func _process(delta):

	total_delta += delta

	if total_delta > 1:
		total_delta = 0
		var ball = Ball.instance()
		ball.position = Vector2(randi() % int(screensize.y), -100)
		print(ball.position)
		$CanvasLayer.add_child(ball)

	if $CanvasLayer/Player.get_slide_count() != 0:
		var collision = $CanvasLayer/Player.get_slide_collision(0)
		if collision != null && collision.collider.is_class('KinematicBody2D'):
			collision.collider.queue_free()
	$Camera2D.move_local_x(200 * delta)
	