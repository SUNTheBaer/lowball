extends Node

@export var world_3d : Node3D
@export var world_2d : Node2D
@export var gui : Control

var current_3d_scene
var current_2d_scene
var current_gui_scene

var mistakes = 0
var savings = 0
var current_model = ""
var current_defects = []

func _ready() -> void:
	print("hello from main")

func offer_accepted(base_price, bought_price, mistake_count):
	print("called offer_accepted")
	savings += base_price - bought_price
	mistakes += mistake_count

func offer_rejected(mistake_count):
	print("called offer_rejected")
	mistakes += mistake_count

func defect_selected(defect: String, toggled_on: bool):
	if toggled_on and defect not in current_defects:
		current_defects.append(defect)
	elif not toggled_on and defect in current_defects:
		current_defects.erase(defect)
	print(current_defects)

func set_model(model_name, model_defects):
	current_model = model_name
	current_defects = model_defects
