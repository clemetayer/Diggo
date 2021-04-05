extends Button

func _on_NoItem_pressed():
	PathFindingItems.setActiveItem("noItem")
	SignalManager.emit_path_finding_item_chosen()
