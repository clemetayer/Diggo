extends Node2D

export(String, FILE) var BGM = "res://Scenes/Sound/BGM/MountainsStream.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.playBGMWithFilter(BGM,2,4)
	$DestructibleSprite.parseSprite()
