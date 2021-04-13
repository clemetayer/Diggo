extends Navigation2D

export(NodePath) var TARGET_START # start target item
export(NodePath) var TARGET_END # end target item
export(NodePath) var PATH_LINE # Line to show when pressing the button of path finding (should be Line2D)

# Called when the node enters the scene tree for the first time.
func _ready():
	if(SignalManager.connect("path_finding_item_chosen",self,"updateTargetEnd") != OK): # LOGGER 
		printerr("Error in PathFinder -> _ready -> SignalManager -> connect (path_finding_item_chosen)")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	inputManager()

# Input management for path finding
func inputManager():
	if(Input.is_action_just_pressed("find path")):
		getPath()

# shows the path from diggo to keyPos in PATH_LINE
func getPath():
	if((PATH_LINE != "") and (get_node(PATH_LINE) is Line2D)):
		get_node(PATH_LINE).points = get_simple_path(get_node(TARGET_START).position,get_node(TARGET_END).position)
		$LineOpacityAnimate.interpolate_property(
			get_node(PATH_LINE),
			"default_color:a",
			1,
			0,
			3)
		$LineOpacityAnimate.start()
	else: 
		printerr("Error : Path line node not present or wrong type") # LOGGER

# updates the end target when an path finding item was chosen
func updateTargetEnd():
	TARGET_END = PathFindingItems.getCurrentPath()
