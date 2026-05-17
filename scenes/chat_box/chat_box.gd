extends Control

signal dialogue_finished

@onready var chat_history: RichTextLabel = $PanelContainer/VBoxContainer/ChatHistory
@onready var typing_indicator: TextureRect = $PanelContainer/VBoxContainer/TypingIndicator
@onready var  choices_box: HBoxContainer = $PanelContainer/VBoxContainer/ChoicesBox

@export var typing_indicator_length: int = 5
var typing_indicator_timer: Timer = Timer.new()
var current_text: String = ""
var current_speaker: String = ""

var dialogue_data: Dictionary = {}
var current_dialogue_id: String

func _ready() -> void:
	typing_indicator_timer.timeout.connect(_on_typing_indicator_timer_timeout)
	add_child(typing_indicator_timer)

func start(data: Dictionary, start_id: String):
	"""Start the dialogue"""
	self.dialogue_data = data
	_show_dialogue(start_id)

func _show_dialogue(id: String):
	if not dialogue_data.has(id):
		push_error("Dialogue ID not found: " + id)
		_end_dialogue()
		return
	
	current_dialogue_id = id
	var entry = dialogue_data[id]
	
	current_speaker = entry.get("speaker", "")
	current_text = entry.get("text", "...")
	
	typing_indicator_timer.start(typing_indicator_length)
	typing_indicator.show()
	
func _on_typing_indicator_timer_timeout():
	typing_indicator_timer.stop()
	var entry = dialogue_data[current_dialogue_id]
	typing_indicator.hide()
	chat_history.text += "\n" + current_speaker + ": " + current_text
	if entry.has("next_id"):
		_show_dialogue(entry["next_id"])
	else:
		pass

func _end_dialogue():
	"""End dialogue and emit signal"""
	dialogue_finished.emit()
