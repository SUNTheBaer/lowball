extends Node

signal model_loaded

var player_name = "Will"
var mistake_count = 0
var savings = 0
var model_name = ""
var model_defects = []
var selected_defects = []

func offer_accepted(base_price, bought_price):
	savings += base_price - bought_price
	check_mistakes()

func offer_rejected():
	check_mistakes()

func check_mistakes():
	var model_defects_array = Array(model_defects)
	var missed_defects = model_defects_array.filter(func(defect): return not selected_defects.has(defect))
	var extra_defects = selected_defects.filter(func(defect): return not model_defects_array.has(defect))
	mistake_count = missed_defects.size() + extra_defects.size()

func defect_selected(defect: String, toggled_on: bool):
	if toggled_on and defect not in selected_defects:
		selected_defects.append(defect)
	elif not toggled_on and defect in selected_defects:
		selected_defects.erase(defect)

func set_model(model_name, model_defects):
	self.model_name = model_name
	self.model_defects = model_defects
	model_loaded.emit(model_name)
