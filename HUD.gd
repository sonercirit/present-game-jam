extends CanvasLayer

signal start_game

func _ready():
	pass

func _on_Start_pressed():
	$Start.hide()
	emit_signal('start_game')
