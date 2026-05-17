extends SubViewport

@onready var market_item_object: Node3D = $MarketItemObject

var expanded = false
signal market_item_clicked
signal market_item_escaped

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and expanded == false:
				market_item_clicked.emit()
				expanded = true
				market_item_object.get_child(0).expanded = true
	
	if event.is_action_pressed("escape"):
		market_item_escaped.emit()
		market_item_object.get_child(0).reset_rotation()
		expanded = false
		market_item_object.get_child(0).expanded = false
