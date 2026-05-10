extends HBoxContainer

@export var defect_values = [""]

func _ready() -> void:
	%Label.text = defect_values[0]

func _on_check_button_toggled(toggled_on: bool) -> void:
	Main.defect_selected(%Label.text, toggled_on)

func page_change(page_number):
	if page_number < defect_values.size():
		if not visible:
			set_visible(true)
		%Label.text = defect_values[page_number]
	else:
		set_visible(false)
	
	if %Label.text in Main.selected_defects:
		%CheckButton.set_pressed_no_signal(true)
	else:
		%CheckButton.set_pressed_no_signal(false)
