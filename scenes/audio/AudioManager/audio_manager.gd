extends Node2D

var audio_logic_tree_scene
var song_controller_scene
var audio_manager_config_scene

func _ready():
	var base_path = get_script().resource_path
	var trimmed_path = base_path.substr(0, len(base_path)-16)
	var audio_manager_config_scene = load(trimmed_path + 'audio_manager_config.tscn')
	var config = audio_manager_config_scene.instance()
	add_child(config)

func _on_configured():
	var config = $audio_manager_config
	var base_path = get_script().resource_path
	var trimmed_path = base_path.substr(0, len(base_path)-16)
	var audio_logic_tree_scene = load(trimmed_path + 'audio_logic_tree_handler.tscn')
	var song_controller_scene = load(trimmed_path + 'song_controller.tscn')
	var audio_logic_tree_handler = audio_logic_tree_scene.instance()
	var song_controller = song_controller_scene.instance()
	audio_logic_tree_handler.set_state_directory(config.state_directory)
	audio_logic_tree_handler.set_audio_actions(config.audio_actions)
	audio_logic_tree_handler.set_trees(config.trees)
	song_controller.set_tracks(config.tracks)
	add_child(audio_logic_tree_handler)
	add_child(song_controller)
	
func _on_state_changed(action):
	$song_controller.handle_action(action)
