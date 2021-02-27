extends Node2D

export(Vector2) var TARGET_POSITION # Position of the target item
export(NodePath) var PATH_FINDING # Path finding of element (should be Navigation2D)
export(NodePath) var PATH_LINE # Line to show when pressing the button of path finding (should be Line2D)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	inputManager()

# Input management for path finding
func inputManager():
	if(Input.is_action_just_pressed("find path")):
		getPath()


# shows the path from diggo to keyPos in PATH_LINE
func getPath():
	if((PATH_FINDING != "") and (get_node(PATH_FINDING) is Navigation2D)):
		if((PATH_LINE != "") and (get_node(PATH_LINE) is Line2D)):
			get_node(PATH_LINE).points = get_node(PATH_FINDING).get_simple_path(position,TARGET_POSITION)
		else:
			print("Error : Path line node not present or wrong type")
	else:
		print("Error : Path find node not present or wrong type")
