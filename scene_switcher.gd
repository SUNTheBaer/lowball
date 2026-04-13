extends Node

var current_vendor = ""
var current_item = ""

func select_to_item_screen(vendor, item):
	
	current_vendor = vendor
	current_item = item
	get_tree().change_scene_to_file("res://levels/vendor_item_screen.tscn")
