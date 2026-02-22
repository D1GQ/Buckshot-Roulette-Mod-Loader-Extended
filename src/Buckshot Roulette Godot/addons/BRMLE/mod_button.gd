extends Node

var mod_main = null

func modify_menu(menu_scene):
	# Find main screen
	var main_screen = _find_node(menu_scene, "main screen")
	if not main_screen:
		var camera = _find_node(menu_scene, "Camera")
		if camera:
			var dialogue_ui = _find_node(camera, "dialogue UI")
			if dialogue_ui:
				var menu_ui = _find_node(dialogue_ui, "menu ui")
				if menu_ui:
					main_screen = _find_node(menu_ui, "main screen")
	
	if not main_screen:
		return
	
	# Find the button containers
	var credits_container = _find_node(main_screen, "true button_credits")
	var exit_container = _find_node(main_screen, "true button_exit")
	
	# Find the actual button nodes
	var credits_btn = _find_node(credits_container, "button class_credits")
	var exit_btn = _find_node(exit_container, "button class_exit")
	
	# Find the labels
	var credits_label = _find_node(main_screen, "button_credits")
	var exit_label = _find_node(main_screen, "button_exit")
	
	if not credits_container or not exit_container or not credits_btn or not exit_btn or not credits_label or not exit_label:
		print("Missing nodes - aborting")
		return
	
	# Figure out spacing between buttons
	var y_spacing = exit_label.position.y - credits_label.position.y
	
	# Duplicate exit container for mods button
	var mods_container = exit_container.duplicate(15)
	mods_container.name = "true button_mods"
	
	# Find and rename the button class
	var mods_btn = _find_node(mods_container, "button class_exit")
	if mods_btn:
		mods_btn.name = "button class_mods"
		mods_btn.set("alias", "mods")
	
	# Duplicate credits label for mods
	var mods_label = credits_label.duplicate()
	mods_label.name = "button_mods"
	mods_label.text = "Mods"
	
	# Connect the button to its label
	if mods_btn:
		mods_btn.set("ui", mods_label)
	
	# Position the new button
	mods_container.position = credits_container.position
	mods_container.position.y = credits_container.position.y + y_spacing
	mods_container.position.x += 22
	
	# Position the new label
	mods_label.position = credits_label.position
	mods_label.position.y = credits_label.position.y + y_spacing
	
	# Move exit button down to make room
	exit_container.position.y += y_spacing
	exit_label.position.y += y_spacing
	
	# Get parent containers
	var label_parent = credits_label.get_parent()
	var button_parent = credits_container.get_parent()
	
	# Find where exit buttons are
	var exit_idx = button_parent.get_children().find(exit_container)
	var exit_label_idx = label_parent.get_children().find(exit_label)
	
	# Add new buttons to scene
	label_parent.add_child(mods_label)
	button_parent.add_child(mods_container)
	
	# Move them into position
	label_parent.move_child(mods_label, exit_label_idx)
	button_parent.move_child(mods_container, exit_idx)
	
	# Set up focus navigation
	if credits_container:
		credits_container.focus_neighbor_bottom = mods_container.get_path()
		credits_container.focus_neighbor_top = credits_container.get_path()
	
	if mods_container:
		mods_container.focus_neighbor_top = credits_container.get_path()
		mods_container.focus_neighbor_bottom = exit_container.get_path()
	
	if exit_container:
		exit_container.focus_neighbor_top = mods_container.get_path()
		exit_container.focus_neighbor_bottom = exit_container.get_path()
	
	# Connect the button press
	if mods_btn and mods_btn.has_signal("is_pressed"):
		mods_btn.is_pressed.connect(_on_mods_pressed)
	
	print("Added Mods button to main menu")

func _find_node(node, name):
	if node.name.to_lower() == name.to_lower():
		return node
	for child in node.get_children():
		var result = _find_node(child, name)
		if result:
			return result
	return null

func _on_mods_pressed():
	if mod_main:
		mod_main.open_mod_list()
