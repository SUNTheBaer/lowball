extends Control

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var market_item_animation_component: MarketItemAnimationComponent = $MarketItemAnimationComponent
@onready var market_item_object: Node3D = $SubViewportContainer/SubViewport/MarketItemObject
@onready var product_mesh: Node3D = $SubViewportContainer/SubViewport/MarketItemObject/ProductMesh
@onready var placeholder: MeshInstance3D = $SubViewportContainer/SubViewport/MarketItemObject/ProductMesh/Placeholder

var model_scene = preload("res://assets/items/Springy Boy Blue.glb")
var market_item_paths = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sub_viewport.market_item_clicked.connect(market_item_animation_component.on_click)
	sub_viewport.market_item_escaped.connect(market_item_animation_component.on_escape)
	placeholder.visible = false
	randomize()
	load_market_items()
	randomize_model()
	display_model()
	
func display_model():
	var instance = model_scene.instantiate()
	product_mesh.add_child(instance)
	
	instance.position = Vector3(0,-1,0)
	
func randomize_model():
	var random_item = market_item_paths.pick_random()
	print("Market Item Loaded: %s" % random_item)
	model_scene = load(random_item)
	
# TODO : Stole this from Will, need to refactor this into a helper function for re-usability and redundancy reasons
func load_market_items():
	var path = "res://assets/items/"
	var dir = DirAccess.open(path)
	
	# Iterate through items directory, adding all paths to array
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".glb"):
				market_item_paths.append(path + "/" + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")
	
 
