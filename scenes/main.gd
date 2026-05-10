extends Node

@export var world_3d : Node3D
@export var world_2d : Node2D
@export var gui : Control

var current_3d_scene
var current_2d_scene
var current_gui_scene

signal model_loaded

var mistake_count = 0
var savings = 0
var model_name = ""
var model_defects = []
var selected_defects = []

func offer_accepted(base_price, bought_price, mistake_count):
	savings += base_price - bought_price
	check_mistakes()
	

func offer_rejected(mistake_count):
	check_mistakes()

func check_mistakes():
	var model_defects_array = Array(model_defects)
	var missed_defects = model_defects_array.filter(func(defect): return not selected_defects.has(defect))
	var extra_defects = selected_defects.filter(func(defect): return not model_defects_array.has(defect))
	mistake_count = missed_defects.size() + extra_defects.size()
	print(mistake_count)

func defect_selected(defect: String, toggled_on: bool):
	if toggled_on and defect not in selected_defects:
		selected_defects.append(defect)
	elif not toggled_on and defect in selected_defects:
		selected_defects.erase(defect)
	print(selected_defects)

func set_model(model_name, model_defects):
	self.model_name = model_name
	self.model_defects = model_defects
	model_loaded.emit(model_name)
	print(model_name)
	print(model_defects)
