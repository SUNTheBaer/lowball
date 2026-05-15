extends Control

var vendor_texture = null
var vendor_sprites = {}
var selected_vendor = ""

var base_price = 0
var counteroffer_price = 0
var mistake_count = 0

var pricing_dictionary = {
	"Monster": 30,
	"BrownBear": 25,
	"SpringyBoyBlue": 40
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_vendor_sprites()
	selected_vendor = vendor_sprites.keys().pick_random()
	%VendorTexture.set_texture(vendor_sprites[selected_vendor])
	DialogueManager.show_dialogue_balloon(load("res://dialogue/" + selected_vendor + ".dialogue"), "start")
	
	var base_price_modifier = randf_range(0.8, 1.2)
	base_price = pricing_dictionary[Main.model_name] * base_price_modifier
	%ItemCost.text = "$%.2f" % base_price

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
				vendor_sprite_paths.append(path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")

	# Iterate through vendor sprite paths array and load sprites into array	
	for sprite_path in vendor_sprite_paths:
		var image = Image.load_from_file(sprite_path)
		var texture = ImageTexture.create_from_image(image)
		vendor_sprites[sprite_path.get_slice(path, 1).get_slice(".", 0)] = texture

#func start_dialogue():
	#var path = "res://dialogue/"
	#var dir = DirAccess.open(path)
	#var vendor_dialogue_path = ""
	#
	## Iterate through dialogue directory, adding all paths to array
	#if dir:
		#dir.list_dir_begin()
		#var file_name = dir.get_next()
		#
		#while file_name != "":
			#if not dir.current_is_dir() and file_name.contains(selected_vendor):
				#vendor_dialogue_path = path + 
			#file_name = dir.get_next()
		#dir.list_dir_end()
	#else:
		#print("An error occurred when trying to access the path.")
	#DialogueManager.show_dialogue_balloon()

func _on_offer_button_pressed() -> void:
	Main.offer_accepted(base_price, counteroffer_price, mistake_count)
	get_tree().reload_current_scene()

func _on_leave_button_pressed() -> void:
	Main.offer_rejected(mistake_count)
	get_tree().reload_current_scene()
