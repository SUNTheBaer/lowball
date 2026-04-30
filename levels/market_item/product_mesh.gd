extends Node3D

var rotating = false
var expanded = false : set = _set_expanded, get = _get_expanded
var default_rotation : Vector3 = Vector3.ZERO

func _ready() -> void:
	default_rotation = rotation
	
func _input(event):
	if expanded == true:
		if event is InputEventMouseButton:
			if event.is_pressed():			
				rotating = true
			
			if event.is_released():
				rotating = false
				
		if event is InputEventMouseMotion and rotating:		
			var delta = get_process_delta_time()
			var rel = event.relative 
			
			rotate_y(rel.x * .7 * delta)
			rotate_x(rel.y * .7 * delta)

func _set_expanded(status):
	expanded = status

func _get_expanded() -> bool:
	return expanded
	
func reset_rotation() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", default_rotation, 0.5).set_trans(Tween.TransitionType.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
