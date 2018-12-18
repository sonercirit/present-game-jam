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
	$Game/Control.hide()
	for child in $Credits.get_children():
		child.hide()
#	for child in $Walls.get_children():
#		child.hide()
	$MenuMusic.play()

func _process(delta):

	if $MenuMusic.playing:
		var menu_music_position = $MenuMusic.get_playback_position()
		if menu_music_position < 8 && !$SoundTween.is_active():
			$SoundTween.interpolate_property($MenuMusic, 'volume_db', -30, 0, 10, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
			$SoundTween.start()
		elif menu_music_position > 93 && !$SoundTween.is_active():
			$SoundTween.interpolate_property($MenuMusic, 'volume_db', 0, -30, 10, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
			$SoundTween.start()

	if game_started:

		var icons = [$Game/Control/IconKoiBlack, $Game/Control/IconKoiWhite]
		for icon in icons:
			$IconTween.interpolate_property(icon, 'rotation_degrees', icon.rotation_degrees, icon.rotation_degrees - 360, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$IconTween.start()
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
#	for debugging / disables game_over	
#	return null
	if score >= 100 || score <= 0:
		$Game/Control.hide()
		for child in $HUD.get_children():
			child.show()
		game_started = false

		for child in $Game.get_children():
			if 'Ball' in child.name:
				child.queue_free()

#		for child in $Walls.get_children():
#			child.hide()
		$GameMusic.playing = false
		$MenuMusic.play()

	var target_white
	var target_black

	if score == 50:
		target_white = Color(1,1,1,0)
		target_black = Color(1,1,1,0)
	elif score > 50:
		target_white = Color(1,1,1,1)
		target_black = Color(1,1,1,0)
	elif score < 50:
		target_white = Color(1,1,1,0)
		target_black = Color(1,1,1,1)

	$IconColorTween.interpolate_property($Game/Control/IconWhite, 'modulate', $Game/Control/IconWhite.modulate, target_white, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$IconColorTween.interpolate_property($Game/Control/IconBlack, 'modulate', $Game/Control/IconBlack.modulate, target_black, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$IconColorTween.start()

func _on_HUD_start_game():
	score = starting_score
	$Game/Control/Score.text = str(score)
	$Game/Control/Player.position = Vector2(-250, 540)
	game_started = true
	$Game/Control.show()
#	for child in $Walls.get_children():
#		child.show()
	$MenuMusic.playing = false
	$MenuMusic.volume_db = -30
	$GameMusic.play()

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

func _on_SoundTween_tween_completed(object, key):
	$SoundTween.stop_all()

func _on_HUD_show_credits():
	for child in $HUD.get_children():
		child.hide()
	for child in $Credits.get_children():
		child.show()

func _on_Credits_go_back_to_main_menu():
	for child in $HUD.get_children():
		child.show()

func _on_IconColorTween_tween_completed(object, key):
#	$IconColorTween.stop_all()
	pass
