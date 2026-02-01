extends PanelContainer
class_name EditorHand

@export var id: int = 1
@export var start_time: float = 0.0
@export var end_time: float = 1.0
@export var bpm: float = 120.0
@export var stride: int = 5

@export var times_label: Label
@export var info_label: Label

signal edit(hand: EditorHand)
signal delete(hand: EditorHand)

const normal_stylebox = preload("res://scenes/leveL_editor/editor_hand/editor_hand_normal.tres")
const highlight_stylebox = preload("res://scenes/leveL_editor/editor_hand/editor_hand_highlight.tres")


func _ready() -> void:
	times_label.text = Utils.format_timestamp(start_time) + " - " + Utils.format_timestamp(end_time)
	info_label.text = str(roundf(bpm * 10) / 10) + " BPM, " + ("+" if stride > 0 else "") + str(stride) + " stride"


func set_highlight(highlight: bool):
	if highlight:
		add_theme_stylebox_override("panel", highlight_stylebox)
	else:
		add_theme_stylebox_override("panel", normal_stylebox)


func _on_edit_pressed() -> void:
	edit.emit(self)


func _on_delete_pressed() -> void:
	delete.emit(self)
