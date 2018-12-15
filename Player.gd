extends KinematicBody2D

var motion = Vector2()
const BASE_MOTION = 400
var total_delta = 0
signal reso

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

	var screensize = get_viewport_rect().size
	var left_threshold = screensize.x * .25
	var left_percent = (left_threshold - (self.position.x - left_threshold)) / left_threshold
#	print(left_percent)
	if left_percent > .02 || left_percent < -.02:
		motion.x += left_percent

	var height_piece_lenght = screensize.y / 9
	var upper_threshold = height_piece_lenght * 1.25
	var position_y = self.position.y - height_piece_lenght * 2
	var upper_percent = (upper_threshold - (position_y - upper_threshold)) / upper_threshold
	if upper_percent > .02 || upper_percent < -.02:
		motion.y += upper_percent
#	print(upper_percent)
#	print(total_delta)
	if left_percent > .98 || left_percent < -.98 || upper_percent > .98 || upper_percent < -.98:
		total_delta = 1
	if total_delta > 0:
		total_delta -= delta
	elif total_delta != 0:
		total_delta = 0

#	print(motion.x)

	if motion.x > 0 && motion.y > 0:
		rotation_degrees = 135
	elif motion.x > 0 && motion.y < 0:
		rotation_degrees = 45
	elif motion.x < 0 && motion.y > 0:
		rotation_degrees = -135
	elif motion.x < 0 && motion.y < 0:
		rotation_degrees = -45
	elif motion.x > 0:
		rotation_degrees = 90
	elif motion.x < 0:
		rotation_degrees = -90
	elif motion.y > 0:
		rotation_degrees = 180
	elif motion.y < 0:
		rotation_degrees = 0

	move_and_slide(motion.normalized() * BASE_MOTION)


func _on_Viewport_size_changed():
	print('size changed')
