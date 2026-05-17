extends Control

@onready var vendor_texture = $VendorTexture
@onready var item_cost = $ItemCost
@onready var item_counteroffer = $ItemCounteroffer
@onready var item_counteroffer_label = $ItemCounteroffer/ItemCounterofferLabel
@onready var chat_box = $ChatBox
@onready var subview_port = $ItemModel/SubViewportContainer/SubViewport
@onready var market_item_animation_component = $ItemModel/MarketItemAnimationComponent
@onready var offer_button = $OfferButton
@onready var leave_button = $LeaveButton
@onready var form = $Form

var vendor_sprites: Dictionary = {}
var selected_vendor: String = ""
var dialogue_content: Dictionary

var base_price: float = 0.0
var counteroffer_price: float = 0.0
@export var mistake_modifier: float = 0.9
var pricing_dictionary: Dictionary = {
	"Monster": 30,
	"BrownBear": 25,
	"SpringyBoyBlue": 40
}

func _ready() -> void:
	_connect_signals()
	_load_vendor()
	_start_dialogue("start")
	_set_price()

func _connect_signals() -> void:
	subview_port.market_item_escaped.connect(_on_market_item_escaped)
	subview_port.market_item_clicked.connect(_on_market_item_clicked)
	market_item_animation_component.transition_done.connect(_on_transition_done)

func _load_vendor() -> void:
	var vendor_sprite_paths : Array = []
	var path: String = "res://assets/vendors/"
	var dir: DirAccess = DirAccess.open(path)
	
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
	
	selected_vendor = vendor_sprites.keys().pick_random()
	vendor_texture.set_texture(vendor_sprites[selected_vendor])

func _start_dialogue(label: String) -> void:
	var path: String = "res://dialogue/" + selected_vendor + ".json"
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open dialogue file")
		return
	var json_text = file.get_as_text()
	json_text = json_text.replacen("[object]", Main.model_name).replacen("[player_name]", Main.player_name)
	dialogue_content = JSON.parse_string(json_text)
	chat_box.dialogue_finished.connect(_on_dialogue_finished)
	chat_box.start(dialogue_content, label)

func _on_dialogue_finished() -> void:
	pass

func _set_price() -> void:
	var base_price_modifier = randf_range(0.8, 1.2)
	base_price = pricing_dictionary[Main.model_name] * base_price_modifier
	item_cost.text = "$%.2f" % base_price

func _on_market_item_escaped() -> void:
	if Main.selected_defects.size() > 0:
		counteroffer_price = base_price * mistake_modifier ** Main.selected_defects.size()
		item_counteroffer_label.text = "$%.2f" % counteroffer_price
		item_counteroffer.show()
		item_cost.hide()
	else:
		item_counteroffer.hide()
		item_cost.show()
	
	offer_button.disabled = false
	leave_button.disabled = false
	form.hide()

func _on_market_item_clicked() -> void:
	offer_button.disabled = true
	leave_button.disabled = true

func _on_transition_done() -> void:
	form.show()

func _on_offer_button_pressed() -> void:
	Main.offer_accepted(base_price, counteroffer_price)
	_start_dialogue("offered")

func _on_leave_button_pressed() -> void:
	Main.offer_rejected()
	_start_dialogue("rejected")
