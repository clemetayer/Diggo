# inspired from Zylann on https://godotengine.org/qa/1883/transfering-a-variable-over-to-another-scene
# also inspired from this tutorial : https://docs.godotengine.org/en/latest/tutorials/io/background_loading.html
extends Node

export(String,FILE) var LOADING_SCREEN = "res://Scenes/Menus/LoadingScreen.tscn"

# Private variable
var _params = null
var loading_screen
var loader
var wait_frames
var time_max = 100 # msec
var current_scene

# FIXME : find a way to not block loading animation while loading destructible sprites
# TODO : add comments here and there
# TODO : add a fade in/out to make loading less ... brutal

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	loading_screen = load(LOADING_SCREEN).instance()

func _process(_time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return
	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return
	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()
		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			# update_progress()
			pass # no update progess
		else: # Error during loading.
			printerr("Error during loading, loader.poll() returned an error (SwitchSceneWithParam:_process)")
			loader = null
			break

# UNUSED : updates the load progress
func update_progress():
	pass
#	var progress = float(loader.get_stage()) / loader.get_stage_count()
	# Update your progress bar? Nope, but maybe someday
	# get_node("progress").set_progress(progress)
	# ...or update a progress animation? Still no
	# var length = get_node("animation").get_current_animation_length()
	# Call this on a paused animation. Use "true" as the second argument to
	# force the animation to update.
	# get_node("animation").seek(progress * length, true)

# sets to the new scene (but might set another wait if additionnal resources)
func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	if(current_scene.get("ADDITIONAL_LOADS") != null and current_scene.ADDITIONAL_LOADS):
		get_node("/root").add_child(current_scene)
		get_node("/root").move_child(current_scene,loading_screen.get_index()) # sets the scene below the loading screen so that it can process while not being visible
		current_scene.connect("loaded",self,"switch_scene")
	else:
		get_node("/root").add_child(current_scene)
		switch_scene()

func switch_scene():
	get_node("/root").remove_child(loading_screen)

# switches scene with loading screen, param is optionnal
# param as a dictionnary
func goto_scene(path, params=null): # Game requests to switch to this scene.
	_params = params
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # Check for errors.
		printerr("Error during scene load, loader == null (SwitchSceneWithParam:goto_scene)")
		return
	set_process(true)
	get_node("/root").remove_child(current_scene)
	current_scene.queue_free() # Get rid of the old scene.
	# Start your "loading..." animation.
	get_node("/root").add_child(loading_screen)
	wait_frames = 1


# Call this instead to be able to provide arguments to the next scene
func change_scene(next_scene, params=null):
	_params = params
	if(get_tree().change_scene(next_scene) != OK):
		printerr("Error in SwitchSceneWithParam::change_scene")

# In the newly opened scene, you can get the parameters by name
func get_param(name):
	if _params != null and _params.has(name):
		return _params[name]
	return null
