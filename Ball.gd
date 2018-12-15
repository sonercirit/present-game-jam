extends KinematicBody2D

var target = Vector2()
var x_percent = 0
var y_percent = 0

func _ready():
	randomize()
	var screensize = get_viewport_rect().size

	var width_min = int(screensize.x * .25)
	var width_max = int(screensize.x * .5)

	var height_piece_lenght = screensize.y / 9
	var height_min = int(height_piece_lenght * 2)
	var height_max = int(height_piece_lenght * 4.5)

	var width = randi() % width_max + width_min
	var height = randi() % height_max + height_min

	target = Vector2(width, height)

	var x_length = abs(position.x - target.x)
	var y_length = abs(position.y - target.y)
	var max_length = max(x_length, y_length)
	x_percent = x_length / max_length
	y_percent = y_length / max_length

func _physics_process(delta):


	if position.x < target.x:
		move_local_x(50 * delta * x_percent)
	elif position.x > target.x:
		move_local_x(-50 * delta * x_percent)

	if position.y < target.y:
		move_local_y(50 * delta * y_percent)
	elif position.y > target.y:
		move_local_y(-50 * delta * y_percent)
