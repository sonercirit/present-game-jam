extends Node

export (PackedScene) var Ball
var total_delta = 0
var screensize = Vector2()
var score = 50

func _ready():
	OS.set_window_maximized(true)
	screensize = get_viewport().size
#	$CanvasLayer/Score.get_font().size

func _process(delta):

	total_delta += delta

	if total_delta > 2:
		total_delta = 0
		var white_ball = Ball.instance()
		white_ball.position = Vector2(randi() % int(screensize.x), -100)
		$CanvasLayer.add_child(white_ball)
		var black_ball = Ball.instance()
		black_ball.position = Vector2(randi() % int(screensize.x), screensize.y + 100)
		black_ball.type = 'black'
		$CanvasLayer.add_child(black_ball)

	if $CanvasLayer/Player.get_slide_count() != 0:
		var collision = $CanvasLayer/Player.get_slide_collision(0)
		if collision != null && collision.collider != null && collision.collider.is_class('KinematicBody2D')\
			&& collision.collider.type != null:
			collision.collider.queue_free()
			var type = collision.collider.type
			if type == 'white':
				score += 10
				$CanvasLayer/Score.text = str(score)
			if type == 'black':
				score -= 10
				$CanvasLayer/Score.text = str(score)
	$Camera2D.move_local_x(200 * delta)
