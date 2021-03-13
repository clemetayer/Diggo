extends Node2D

# TODO : fix a bit the tilemap looking a bit weird on some spots
# TODO : add warning panels in front of the cliff (add another panel each time the player jumps off the cliff)
# TODO : add a Game over transition if the player jumps off the cliff
# TODO : Game over screen + different texts each time the player jumps off the cliff
# TODO : maybe scale everything down to save resources

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

export(bool) var ADDITIONAL_LOADS = true # tells the scene switcher that there are additionnal resources to load on ready
signal loaded() # signal to tell the scene switcher that everything is loaded

func _on_DestructibleTilemap_destructible_loaded():
	emit_signal("loaded")
