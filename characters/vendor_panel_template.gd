extends Panel

func _on_button_pressed() -> void:
	get_node("/root/SceneSwitcher").select_to_item_screen(get_node("VendorSprite").name, get_node("SubViewport/MeshInstance3D").name)
	
