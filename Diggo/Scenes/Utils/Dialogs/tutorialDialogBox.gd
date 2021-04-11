extends RichTextLabel

export(String) var dialog = "" # dialog string
export(NodePath) var TARGET # target to follow
export(Vector2) var OFFSET = Vector2(-100,50) # offset from the target

var targetNode

# Called when the node enters the scene tree for the first time.
func _ready():
	targetNode = get_node(TARGET)
	self.hide()

func _process(_delta):
	rect_position = targetNode.position + OFFSET 

# Starts the dialog 
func startDialog():
	self.show()
	set_bbcode(dialog)
