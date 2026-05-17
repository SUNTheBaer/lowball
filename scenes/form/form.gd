extends VBoxContainer

signal page_changed(new_page)

@export var MAX_PAGE_COUNT = 0
var page_count = 0
var page_back = null
var page_forward = null
var defect_selects = []

func _ready() -> void:
	page_back = get_node("HBoxContainer/PageBack")
	page_back.set_visible(false)
	page_forward = get_node("HBoxContainer/PageForward")
	defect_selects = get_node("HBoxContainer/VBoxContainer").get_children()

func _on_page_forward_pressed() -> void:
	if page_count < MAX_PAGE_COUNT:
		page_count += 1
		if page_count == 1:
			page_back.set_visible(true)
		elif page_count == MAX_PAGE_COUNT:
			page_forward.set_visible(false)
		_change_defects()

func _on_page_back_pressed() -> void:
	if page_count >= 1:
		page_count -= 1
		if page_count == 0:
			page_back.set_visible(false)
		elif page_count == MAX_PAGE_COUNT - 1:
			page_forward.set_visible(true)
		_change_defects()

func _change_defects():
	for defect_select in defect_selects:
			defect_select.page_change(page_count)

#func set_visibility(visible: bool):
	#self.set_visibility(visible)
