extends Node

signal go_back_to_main_menu

func _ready():
	$Names.text = 'Cansu Arseven\n\nSoner Cirit\n\nTrebblofang (Menu Sound)\nAndrewkn (Game Sound)\n\nCadson Demak (itim)\nTypeSETit (playball)'
	$Labels.text = 'Artist:\n\nCoder:\n\nSound:\n\n\nFonts:'

func _on_Button_pressed():
	for child in get_children():
		child.hide()
	emit_signal('go_back_to_main_menu')
