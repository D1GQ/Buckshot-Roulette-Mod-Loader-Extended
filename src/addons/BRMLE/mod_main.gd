extends Node

const MOD_ID = "D1GQ-BRMLE"

var mod_menu = null
var menu_button = null
var mod_store = null

const ModButtonScript = preload("res://addons/BRMLE/mod_button.gd")
const ModListMenuScript = preload("res://addons/BRMLE/mod_list_menu.gd")

func _ready():
	print("Mod List loaded - waiting for menu")
	
	# Store reference to ModLoaderStore
	mod_store = get_node_or_null("/root/ModLoaderStore")
	if mod_store:
		print("Found ModLoaderStore reference")
	
	get_tree().node_added.connect(_on_node_added)
	call_deferred("_check_current_scene")

func _check_current_scene():
	var menu = get_tree().current_scene
	if menu and menu.scene_file_path == "res://scenes/menu.tscn":
		await get_tree().process_frame
		await get_tree().process_frame
		_modify_menu(menu)

func _on_node_added(node):
	if node.scene_file_path == "res://scenes/menu.tscn":
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		_modify_menu(node)

func _modify_menu(menu_scene):
	# Create button handler
	menu_button = ModButtonScript.new()
	menu_button.mod_main = self
	menu_button.modify_menu(menu_scene)

func open_mod_list():
	print("Opening mod list")
	
	# Close existing menu if open
	if mod_menu and is_instance_valid(mod_menu):
		mod_menu.queue_free()
		mod_menu = null
		return
	
	# Create new menu and pass the mod store reference
	mod_menu = ModListMenuScript.new()
	mod_menu.set_mod_store(mod_store)
	mod_menu.connect("tree_exited", Callable(self, "_on_menu_closed"))
	get_tree().current_scene.add_child(mod_menu)

func _on_menu_closed():
	mod_menu = null
