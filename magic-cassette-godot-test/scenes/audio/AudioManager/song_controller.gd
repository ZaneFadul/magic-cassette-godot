extends Node2D

#=====Tracks
@onready var tracks : set = set_tracks
func set_tracks(t): tracks = t

@onready var control_functions = $control_functions
@onready var control_types = {
	'play': Callable(control_functions, 'play'),
	'transition_to': Callable(control_functions, 'transition_to'),
	'cut_to': Callable(control_functions, 'cut_to'),
	'play_sfx': Callable(control_functions, 'play_sfx'),
	'fade_out': Callable(control_functions, 'fade_out')
}

func _ready():
	$control_functions.handler = $song_handler
	$control_functions.has_handler = true
	
func load_track(name, song_params = {'on_end': 'loop'}):
	$song_handler.load_track(tracks[name], song_params)

func get_track(name):
	return tracks[name]
	
func play(name, song_params):
	$song_handler.clear()
	load_track(name, song_params)
	
func clear():
	$song_handler.clear()
	
func handle_action(action):
	clear()
	var action_type = null
	for sub_action in action:
		action_type = sub_action
		if control_types.has(action_type):
			control_types[action_type].call(action[action_type])
	
func _on_load_track_request(name, song_params):
	load_track(name, song_params)
	
func get_current_songs():
	return $song_handler.get_current_songs()
