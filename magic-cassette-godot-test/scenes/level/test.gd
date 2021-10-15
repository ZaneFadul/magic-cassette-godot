extends Node2D

func _process(_delta):
	if Input.is_action_pressed('ui_down'):
		$globals.index = 2
	if Input.is_action_pressed('ui_up'):
		$globals.index = 1
	if Input.is_action_pressed('ui_left'):
		$globals.index = 0
