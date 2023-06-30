extends Node

#--------------------------------------------------------
# Scene paths aren't preloaded
const GAME_SCENES = { # A dictionary of predefined scenes with string tags.  If the tag doesn't exist when loading, assumes path if absolute.
"game_world": "res://Game States/Game World/game_world.tscn"
}

# Preload loading screen scene
var loading_scene = preload("res://Loading Screen/loading_screen.tscn")
#--------------------------------------------------------



#--------------------------------------------------------
func load_scene(current_scene, next_scene):

	# Create a new loading scene from the root
	var loading_scene_instance = loading_scene.instantiate()
	get_tree().get_root().call_deferred("add_child",loading_scene_instance)

	# Finds the path to the scene file. (needs to fetch from GAME_SCENES if applicable)
	var load_path : String
	if GAME_SCENES.has(next_scene): # If the scene is predefined, load the tags value.  Otherwise load the given path.
		load_path = GAME_SCENES[next_scene]
	else:
		load_path = next_scene

	var loader_next_scene
	if ResourceLoader.exists(load_path):
		loader_next_scene = ResourceLoader.load_threaded_request(load_path)

	# Check if file exists
	if loader_next_scene == null:
		# handle your error
		print("error: Attempting to load non-existent file!")
		return

	# Waits until the loading scene signals that it's safe to load (aka full screen covered)
	await loading_scene_instance.safe_to_load
	current_scene.queue_free()



	# Continually check status of loading thread to update progress bar, and break when finished.
	while true:
		var load_progress = []
		var load_status = ResourceLoader.load_threaded_get_status(load_path, load_progress)

		# when we get a chunk of data
		match load_status:
			0: # THREAD_LOAD_INVALID_RESOURCE
				print("error: Cannot load, resource is invalid.")
				return

			1: # THREAD_LOAD_IN_PROGRESS
				# Update progress bar value on loading screen
				loading_scene_instance.update_load_progress_bar(load_status)

			2: # THREAD_LOAD_FAILED
				print("error: Loading failed!")
				return

			3: # THREAD_LOAD_LOADED
				# Scene is loaded, now create an instance and add it as a child
				var next_scene_instance = ResourceLoader.load_threaded_get(load_path).instantiate()
				get_tree().get_root().call_deferred("add_child", next_scene_instance)
				return
#--------------------------------------------------------
