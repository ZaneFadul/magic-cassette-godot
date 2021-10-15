extends Node2D


var modes = ['ice_mode', 'base_mode', 'fire_mode']
var index = 1
var mode = modes[index]

func getMode():
	return mode
	
func _process(_delta):
	mode = modes[index]
