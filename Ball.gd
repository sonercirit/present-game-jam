extends KinematicBody2D

export (String) var type

var initial_target = Vector2()
var target = Vector2()
var x_percent = 0
var y_percent = 0
var screensize = Vector2()
var at_position = false
var stage = 0

func _ready():

	if type == 'black':
		$AnimatedSprite.play('black')
	else:
		$AnimatedSprite.play('white')

	randomize()
	screensize = get_viewport_rect().size

	var width_min = int(screensize.x * .5)
	var width_max = int(screensize.x) - width_min

	var height_piece_lenght = screensize.y / 9
	var height_min = int(height_piece_lenght * 2.5)
	var height_max = int(height_piece_lenght * 6.5) - height_min

	var width = randi() % width_max + width_min
	var height = randi() % height_max + height_min

	target = Vector2(width, height)
	initial_target = Vector2(width, height)

	var x_length = abs(position.x - target.x)
	var y_length = abs(position.y - target.y)
	var max_length = max(x_length, y_length)
	x_percent = x_length / max_length
	y_percent = y_length / max_length

	$Tween.interpolate_property(self, "position", self.position, target, 10, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _physics_process(delta):

	if at_position:
		stage += 1
		at_position = false
		var part = screensize.y / 10 / 2
		if stage == 1:
			target = Vector2(initial_target.x - part, initial_target.y)
#			move_and_slide(Vector2(-1,0).normalized() * part)
		if stage == 2:
			target = Vector2(initial_target.x - (part * .92), initial_target.y + (part * .38))
#			move_and_slide(Vector2(-1,1).normalized() * part)
		if stage == 3:
			target = Vector2(initial_target.x - (part * .7), initial_target.y + (part * .7))
#			move_and_slide(Vector2(-1,1).normalized() * part)
		if stage == 4:
			target = Vector2(initial_target.x - (part * .38), initial_target.y + (part * .92))
#			move_and_slide(Vector2(-1,1).normalized() * part)
		if stage == 5:
			target = Vector2(initial_target.x, initial_target.y + part)
#			move_and_slide(Vector2(0,1).normalized() * part)
		if stage == 6:
			target = Vector2(initial_target.x + (part * .38), initial_target.y + (part * .92))
#			move_and_slide(Vector2(1,1).normalized() * part)
		if stage == 7:
			target = Vector2(initial_target.x + (part * .7), initial_target.y + (part * .7))
#			move_and_slide(Vector2(1,1).normalized() * part)
		if stage == 8:
			target = Vector2(initial_target.x + (part * .92), initial_target.y + (part * .38))
#			move_and_slide(Vector2(1,1).normalized() * part)
		if stage == 9:
			target = Vector2(initial_target.x + part, initial_target.y)
#			move_and_slide(Vector2(1,0).normalized() * part)
		if stage == 10:
			target = Vector2(initial_target.x + (part * .92), initial_target.y - (part * .38))
#			move_and_slide(Vector2(1,-1).normalized() * part)
		if stage == 11:
			target = Vector2(initial_target.x + (part * .7), initial_target.y - (part * .7))
#			move_and_slide(Vector2(1,-1).normalized() * part)
		if stage == 12:
			target = Vector2(initial_target.x + (part * .38), initial_target.y - (part * .92))
#			move_and_slide(Vector2(1,-1).normalized() * part)
		if stage == 13:
			target = Vector2(initial_target.x, initial_target.y - part)
#			move_and_slide(Vector2(0,-1).normalized() * part)
		if stage == 14:
			target = Vector2(initial_target.x - (part * .38), initial_target.y - (part * .92))
#			move_and_slide(Vector2(-1,-1).normalized() * part)
		if stage == 15:
			target = Vector2(initial_target.x - (part * .7), initial_target.y - (part * .7))
#			move_and_slide(Vector2(-1,-1).normalized() * part)
		if stage == 16:
			target = Vector2(initial_target.x - (part * .92), initial_target.y - (part * .38))
#			move_and_slide(Vector2(-1,-1).normalized() * part)
			initial_target = Vector2(initial_target.x - part, initial_target.y)
			stage = 0
		var animation_time = .25
		if stage == 1:
			animation_time = 1
		$Tween.interpolate_property(self, "position", self.position, target, animation_time, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		$Tween.start()

func _on_Tween_tween_completed(object, key):
	at_position = true

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_AnimatedSprite_frame_changed():
	var frame = $AnimatedSprite.frame

	if frame == 0 || frame >= 6:
		$frame0.disabled = false
		$frame1.disabled = true
		$frame2.disabled = true
	elif frame == 1 || frame == 5:
		$frame0.disabled = true
		$frame1.disabled = false
		$frame2.disabled = true
	elif frame <= 5 && frame >= 2:
		$frame0.disabled = true
		$frame1.disabled = true
		$frame2.disabled = false
