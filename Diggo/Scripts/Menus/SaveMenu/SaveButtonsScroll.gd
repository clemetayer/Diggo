extends ScrollContainer

# filters the save buttons with text
func filterSavesInput(text):
	for node in $SavesVBox.get_children():
		if(node.has_method("matchesText")):
			if(node.matchesText(text)):
				node.show()
			else:
				node.hide()

# filters the save buttons when text changed
func _on_SearchInput_text_changed(new_text):
	filterSavesInput(new_text)
