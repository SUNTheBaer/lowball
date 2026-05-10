extends Control

var vendor_texture = null
var vendor_sprites = []

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
	%VendorTexture.set_texture(vendor_sprites.pick_random())
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

func _on_offer_button_pressed() -> void:
	Main.offer_accepted(base_price, counteroffer_price, mistake_count)
	self._ready()

func _on_leave_button_pressed() -> void:
	Main.offer_rejected(mistake_count)
	self._ready()
