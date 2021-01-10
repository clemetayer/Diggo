extends ScrollContainer

func filterSavesInput(text):
	for node in $SavesVBox.get_children():
		if(node.has_method("matchesText") 
		   and node.has_method("isNewFileButton") 
		   and not node.isNewFileButton()):
			if(node.matchesText(text)):
				node.show()
			else:
				node.hide()

func _on_SearchInput_text_changed(new_text):
	filterSavesInput(new_text)
