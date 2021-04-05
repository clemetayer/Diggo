extends Button

func _on_BallOfDestiny_pressed():
	PathFindingItems.setActiveItem("ballOfReality")
	SignalManager.emit_path_finding_item_chosen()
