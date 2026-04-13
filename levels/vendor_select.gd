extends Node2D

var vendor_panels = []
var vendor_sprites = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_vendor_sprites()

	vendor_panels = [get_node("VendorPanelTemplate1"), get_node("VendorPanelTemplate2"), get_node("VendorPanelTemplate3"), get_node("VendorPanelTemplate4")]
	for vendor_panel in vendor_panels:
		vendor_panel.get_node("VendorSprite").set_texture(vendor_sprites.pick_random())
	
	#TODO
	#Ensure same vendor doesn't get selected twice
	#Change name of node so that scene_switcher can use node name for parameter
	#Populate items randomly

func load_vendor_sprites():
	var vendor_sprite_paths = []
	var path = "res://assets/vendors/"
	var dir = DirAccess.open(path)
	
	# Iterate through vendor sprite directory, adding all paths to array
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".png"):
				vendor_sprite_paths.append(path + "/" + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")

	# Iterate through vendor sprite paths array and load sprites into array	
	for sprite_path in vendor_sprite_paths:
		var image = Image.load_from_file(sprite_path)
		var texture = ImageTexture.create_from_image(image)
		vendor_sprites.append(texture)
