extends CanvasLayer

signal start_game
signal show_credits

func _ready():
	pass

func _on_Start_pressed():
	hide_HUD()
	emit_signal('start_game')

func _on_Credits_pressed():
	hide_HUD()
	emit_signal('show_credits')

func hide_HUD():
	$Start.hide()
	$Title.hide()
	$Credits.hide()
