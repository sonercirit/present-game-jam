extends KinematicBody2D

var motion = Vector2()
const BASE_MOTION = 300
var total_delta = 0
var left_threshold = 0
var upper_threshold = 0
var screensize = Vector2()
var height_piece_lenght = 0
var did_turn_idle = false

func _ready():

	$AnimatedSprite.play()
	screensize = get_viewport_rect().size
	left_threshold = screensize.x * .25
	
	height_piece_lenght = screensize.y / 9
	upper_threshold = height_piece_lenght * 1.25


func _physics_process(delta):

	var right_button = Input.is_action_pressed("ui_right")
	var left_button = Input.is_action_pressed("ui_left")
	var up_button = Input.is_action_pressed("ui_up")
	var down_button = Input.is_action_pressed("ui_down")
	motion.x = 0
	motion.y = 0

	if total_delta == 0:
		if right_button:
			motion.x += 1
		if left_button:
			motion.x -= 1

		if down_button:
			motion.y += 1
		if up_button:
			motion.y -= 1

	var left_percent = (left_threshold - (self.position.x - left_threshold)) / left_threshold
	var position_y = self.position.y - height_piece_lenght * 2
	var upper_percent = (upper_threshold - (position_y - upper_threshold)) / upper_threshold


	if left_percent > .02 || left_percent < -.02:
		motion.x += left_percent

	if upper_percent > .02 || upper_percent < -.02:
		motion.y += upper_percent

	if left_percent > .98 || left_percent < -.98 || upper_percent > .98 || upper_percent < -.98:
		total_delta = .1
	if total_delta > 0:
		total_delta -= delta
	elif total_delta != 0:
		total_delta = 0

	var next_vector = Vector2(screensize.x / 2, screensize.y / 2)
	if total_delta == 0:
		if right_button && down_button:
			next_vector = Vector2(position.x + 100, position.y + 100)
		elif right_button && up_button:
			next_vector = Vector2(position.x + 100, position.y - 100)
		elif left_button && down_button:
			next_vector = Vector2(position.x - 100, position.y + 100)
		elif left_button && up_button:
			next_vector = Vector2(position.x - 100, position.y - 100)
		elif right_button:
			next_vector = Vector2(position.x + 100, position.y)
		elif left_button:
			next_vector = Vector2(position.x - 100, position.y)
		elif down_button:
			next_vector = Vector2(position.x, position.y + 100)
		elif up_button:
			next_vector = Vector2(position.x, position.y - 100)
	var next_rotation = rad2deg(self.get_angle_to(next_vector))

	if rotation_degrees != next_rotation:
		$Tween.interpolate_property(self, "rotation_degrees", self.rotation_degrees, self.rotation_degrees + next_rotation, .5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()

	var middle = Vector2(screensize.x / 2, screensize.y / 2)
	var part = screensize.y / 100
	var is_idle = (middle.x - part < position.x && middle.x + part > position.x && middle.y - part < position.y && middle.x + part > position.x)
	if next_rotation > 30:
		if !$AnimatedSprite.animation == 'turn':
			$AnimatedSprite.flip_v = true
			$AnimatedSprite.play('turn')
	elif next_rotation < -30:
		if !$AnimatedSprite.animation == 'turn':
			$AnimatedSprite.flip_v = false
			$AnimatedSprite.play('turn')
	elif is_idle:
		$AnimatedSprite.flip_v= false
		if did_turn_idle:
			$AnimatedSprite.play('idle')
		elif !did_turn_idle:
			$AnimatedSprite.play('turn_idle')
	else:
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.play('default')

	if !is_idle:
		did_turn_idle = false

	move_and_slide(motion.normalized() * BASE_MOTION)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'turn_idle':
		did_turn_idle = true


func _on_AnimatedSprite_frame_changed():
	var frame = $AnimatedSprite.frame
	var animation = $AnimatedSprite.animation

	$default5.disabled = true
	$default4.disabled = true
	$default3.disabled = true
	$default2.disabled = true
	$default.disabled = true
	$turn0.disabled = true
	$turn1.disabled = true
	$turn2.disabled = true
	$turn3.disabled = true
	$turn4.disabled = true
	$turn6.disabled = true
	$idle1.disabled = true
	$idle2.disabled = true
	$idle3.disabled = true
	$idle4.disabled = true
	$idle5.disabled = true
	$idle6.disabled = true
	$idle7.disabled = true
	$idle8.disabled = true

	$default5.visible = false
	$default4.visible = false
	$default3.visible = false
	$default2.visible = false
	$default.visible = false
	$turn0.visible = false
	$turn1.visible = false
	$turn2.visible = false
	$turn3.visible = false
	$turn4.visible = false
	$turn6.visible = false
	$idle1.visible = false
	$idle2.visible = false
	$idle3.visible = false
	$idle4.visible = false
	$idle5.visible = false
	$idle6.visible = false
	$idle7.visible = false
	$idle8.visible = false

	if animation == 'default' && frame <= 1:
		$default5.disabled = false
		$default5.visible = true
	elif animation == 'default' && frame == 2:
		$default4.disabled = false
		$default4.visible = true
	elif animation == 'default' && frame == 3:
		$default3.disabled = false
		$default3.visible = true
	elif animation == 'default' && frame == 4:
		$default2.disabled = false
		$default2.visible = true
	elif animation == 'default' && frame >= 5:
		$default.disabled = false
		$default.visible = true

	var is_flipped = $AnimatedSprite.flip_v
	var turn

	if animation == 'turn' && frame == 0:
		turn = $turn0
	elif animation == 'turn' && frame == 1:
		turn = $turn1
	elif animation == 'turn' && (frame == 2 || frame == 5):
		turn = $turn2
	elif animation == 'turn' && frame == 3:
		turn = $turn3
	elif animation == 'turn' && frame == 4:
		turn = $turn4
	elif animation == 'turn' && frame == 6:
		turn = $turn6
	elif animation == 'turn' && frame == 7:
#		turn = $default3 TODO
		$default3.disabled = false
		$default3.visible = true

	if turn != null:
		if is_flipped:
			if turn.position.y < 0:
				turn.position.y = abs(turn.position.y)
		elif !is_flipped:
			if turn.position.y > 0:
				turn.position.y = turn.position.y * -1
		turn.visible = true
		turn.disabled = false

	if animation == 'idle' && frame == 0:
		$idle1.disabled = false
		$idle1.visible = true
	elif animation == 'idle' && frame == 1:
		$idle2.disabled = false
		$idle2.visible = true
	elif animation == 'idle' && frame == 2:
		$idle3.disabled = false
		$idle3.visible = true
	elif animation == 'idle' && frame == 3:
		$idle4.disabled = false
		$idle4.visible = true
	elif animation == 'idle' && frame == 4:
		$idle5.disabled = false
		$idle5.visible = true
	elif animation == 'idle' && frame == 5:
		$idle6.disabled = false
		$idle6.visible = true
	elif animation == 'idle' && frame == 6:
		$idle7.disabled = false
		$idle7.visible = true
	elif animation == 'idle' && frame == 7:
		$idle8.disabled = false
		$idle8.visible = true
