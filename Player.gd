extends KinematicBody2D

var motion = Vector2()
const BASE_MOTION = 400

func _physics_process(delta):

	var right_button = Input.is_action_pressed("ui_right")
	var left_button = Input.is_action_pressed("ui_left")
	var up_button = Input.is_action_pressed("ui_up")
	var down_button = Input.is_action_pressed("ui_down")
	motion.x = 0
	motion.y = 0

	if right_button:
		motion.x += 1
	if left_button:
		motion.x -= 1

	if down_button:
		motion.y += 1
	if up_button:
		motion.y -= 1

	print(motion.normalized() * BASE_MOTION)
	move_and_slide(motion.normalized() * BASE_MOTION)
