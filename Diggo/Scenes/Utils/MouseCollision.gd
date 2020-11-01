extends Area2D

var blockArea = preload("res://Scenes/Utils/Blocks/BlockArea.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getCollisionRadius():
	return 40

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_global_mouse_position()
