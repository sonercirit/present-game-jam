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
