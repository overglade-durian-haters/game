extends CanvasLayer

@export var conductor: Conductor

@export var start_input: Range
@export var end_input: Range
@export var bpm_input: Range
@export var stride_input: Range
@export var initial_input: Range

@export var close_button: Button

var editing: Dictionary
var ignore_updates := false

signal updated


func open(hand: Dictionary):
	editing = hand
	
	var length = conductor.audio.get_length()
	start_input.max_value = length
	end_input.max_value = length
	
	ignore_updates = true
	start_input.value = hand["start_time"]
	end_input.value = hand["end_time"]
	bpm_input.value = hand["bpm"]
	stride_input.value = hand["stride"]
	initial_input.value = hand["initial_offset"]
	ignore_updates = false
	
	show()


func _on_edited(_value: float):
	if not ignore_updates:
		editing["start_time"] = start_input.value
		editing["end_time"] = end_input.value
		editing["bpm"] = bpm_input.value
		editing["stride"] = int(stride_input.value)
		editing["initial_offset"] = int(initial_input.value)
		updated.emit()


func _on_close_pressed() -> void:
	hide()
