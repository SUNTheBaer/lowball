class_name MarketItemAnimationComponent extends Node

@export var from_center: bool = true
@export var hover_scale: Vector2 = Vector2(1,1)
@export var final_transparency: float = 0.176
@export var hover_time: float = 0.25
@export var initial_modulate_time : float = 0.25
@export var escape_modulate_time : float = 0.25
@export var zoom_time: float = 0.5
@export var transition_type: Tween.TransitionType
@export var ease_type : Tween.EaseType = Tween.EASE_OUT

signal transition_done

var target : Control
var target_child : Control
var background : Control
var default_scale : Vector2
var default_target_z_index : int
var default_target_child_z_index : int
var default_target_offsets : Array[float] = [0, 0, 0, 0]
var default_target_anchors : Array[float] = [0, 0, 0, 0]
var default_target_child_offsets : Array[float] = [0, 0, 0, 0]
var default_target_child_anchors : Array[float] = [0, 0, 0, 0]
enum anchors { anchor_left, anchor_top, anchor_right, anchor_bottom }
enum offsets { offset_left, offset_top, offset_right, offset_bottom }
var expanded : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_parent()
	target_child = get_parent().get_node("SubViewportContainer")
	background = get_parent().get_node("Background")
	
	connect_signals()
	call_deferred("setup")

func setup() -> void:
	if from_center:
		target.pivot_offset = target.size / 2
	default_scale = target.scale
	default_target_z_index = target.z_index
	default_target_child_z_index = target_child.z_index
	default_target_offsets = [target.offset_left, target.offset_top, target.offset_right, target.offset_bottom]
	default_target_anchors = [target.anchor_left, target.anchor_top, target.anchor_right, target.anchor_bottom]
	default_target_child_offsets = [target_child.offset_left, target_child.offset_top, target_child.offset_right, target_child.offset_bottom]
	default_target_child_anchors = [target_child.anchor_left, target_child.anchor_top, target_child.anchor_right, target_child.anchor_bottom]
	
func connect_signals() -> void:
	target.mouse_entered.connect(on_hover)
	target.mouse_exited.connect(off_hover)
	
func on_hover() -> void:
	if !expanded:
		hover_tween(hover_scale)
	
func off_hover() -> void:
	if !expanded:
		hover_tween(default_scale)
	
func on_click() -> void:	
	await off_hover()
	
	expanded = true
	
	var tween = get_tree().create_tween().set_parallel(true)
	
	target.z_index = 100
	target_child.z_index = 100
	
	# Set anchors to full rect
	zoom_tween(tween, target, anchors, [0.0, 0.0, 1.0, 1.0])
	zoom_tween(tween, target_child, anchors, [0.0, 0.0, 1.0, 1.0])
	
	# Set offset to 0, so the item is aligned with container
	zoom_tween(tween, target, offsets, [0.0, 0.0, 0.0, 0.0])
	zoom_tween(tween, target_child, offsets, [0.0, 0.0, 0.0, 0.0])
	
	await tween.finished
	
	var translucent_tween = get_tree().create_tween().set_parallel(true)
	
	# Make background appear
	var translucent = Color.GOLDENROD
	modulate_tween(translucent_tween, translucent, initial_modulate_time)
	
	await translucent_tween.finished
	
	transition_done.emit()
	
func on_escape() -> void:
	$"../../Form".set_visible(false)
	
	var invis_tween = get_tree().create_tween().set_parallel(true)
	
	# Make background disappear
	var invisible  = Color(0.0, 0.0, 0.0, 0)
	modulate_tween(invis_tween, invisible, escape_modulate_time)
	
	await invis_tween.finished
	
	var tween = get_tree().create_tween().set_parallel(true)
	
	# Set anchors to default values
	zoom_tween(tween, target, anchors, default_target_anchors)
	zoom_tween(tween, target_child, anchors, default_target_child_anchors)
	
	# Set offset to default, so the item is aligned with container
	zoom_tween(tween, target, offsets, default_target_offsets)
	zoom_tween(tween, target_child, offsets, default_target_child_offsets)
	
	await tween.finished
	
	target.z_index = default_target_z_index
	target_child.z_index = default_target_child_z_index
	
	expanded = false
	
func hover_tween(scale):
	var tween = get_tree().create_tween()
	tween.tween_property(target, "scale", scale, hover_time).set_trans(transition_type).set_ease(ease_type)
	await tween.finished
	
func modulate_tween(tween, color, time):
	tween.tween_property(background, "modulate", color, time).set_trans(transition_type).set_ease(ease_type)
	
func zoom_tween(tween : Tween, target_node, properties, points : Array[float]) -> void:
	for i in range(4):
		tween.tween_property(target_node, properties.find_key(i) , points[i], zoom_time).set_trans(transition_type).set_ease(ease_type)
