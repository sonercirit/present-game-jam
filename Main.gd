extends Node

export (PackedScene) var Ball
var total_delta = 0
var screensize = Vector2()
export (int) var starting_score
var score
signal game_over
var game_started = false

func _ready():
	screensize = get_viewport().size
	OS.set_window_maximized(true)
#	$Game/Score.get_font().size
	$Game/Control.hide()
	for child in $Walls.get_children():
		child.hide()

func _process(delta):

	if game_started:
		total_delta += delta
		if total_delta > 2:
			total_delta = 0
			spawn_balls(get_ball_count_to_spawn())

		if $Game/Control/Player.get_slide_count() != 0:
			var collision = $Game/Control/Player.get_slide_collision(0)
			if collision != null && collision.collider != null && collision.collider.is_class('KinematicBody2D')\
				&& collision.collider.type != null:
				collision.collider.queue_free()
				var type = collision.collider.type
				if type == 'white':
					score += 10
					$Game/Control/Score.text = str(score)
					is_game_over()
				elif type == 'black':
					score -= 10
					$Game/Control/Score.text = str(score)
					is_game_over()
		$Camera2D.move_local_x(200 * delta)

func is_game_over():
	if score >= 100 || score <= 0:
		$Game/Control.hide()
		$Game/Control/Player/CollisionPolygon2D.disabled = true
		$HUD/Start.show()
		game_started = false

		for child in $Game.get_children():
			if 'Ball' in child.name:
				child.queue_free()

		for child in $Walls.get_children():
			child.hide()

func _on_HUD_start_game():
	score = starting_score
	$Game/Control/Score.text = str(score)
	$Game/Control/Player.position = Vector2(-250, 540)
	$Game/Control/Player/CollisionPolygon2D.disabled = false
	game_started = true
	$Game/Control.show()
	for child in $Walls.get_children():
		child.show()

func get_ball_count_to_spawn():
	var white_count = 0
	var black_count = 0
	for child in $Game.get_children():
		if 'Ball' in child.name:
			if child.type == 'white':
				white_count += 1
			elif child.type == 'black':
				black_count += 1
	if white_count > black_count:
		black_count = white_count - black_count + 1
		white_count = 1
	elif black_count > white_count:
		white_count = black_count - white_count + 1
		black_count = 1
	elif white_count == black_count:
		white_count = 1
		black_count = 1
	return [white_count, black_count]

func spawn_balls(count):
	for i in range(count[0]):
		var white_ball = Ball.instance()
		white_ball.position = Vector2(randi() % int(screensize.x), -100)
		$Game.add_child(white_ball)

	for i in range(count[1]):
		var black_ball = Ball.instance()
		black_ball.position = Vector2(randi() % int(screensize.x), screensize.y + 100)
		black_ball.type = 'black'
		$Game.add_child(black_ball)
