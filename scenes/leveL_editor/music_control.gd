extends Node
class_name EditorMusicControl

@export var conductor: Conductor
@export var play_button: Button
@export var progress_bar: HSlider
@export var progress_label: Label

const icon_play = preload("res://assets/images/icon_play.png")
const icon_pause = preload("res://assets/images/icon_pause.png")

var dragging := false


func _ready() -> void:
	call_deferred("_update_music")


func _process(_delta: float) -> void:
	if not dragging:
		_update_progress()


func _update_music() -> void:
	progress_bar.max_value = conductor.audio.get_length()


func _update_progress() -> void:
	progress_bar.value = conductor.playback_pos
	_update_labels()


func _update_labels() -> void:
	progress_label.text = Utils.format_timestamp(progress_bar.value) + " / " + Utils.format_timestamp(conductor.audio.get_length())
	play_button.icon = icon_pause if conductor.playing else icon_play


func seek(delta: float) -> void:
	var pos = min(conductor.audio.get_length(), max(0, conductor.playback_pos + delta))
	conductor.play(pos)


func _on_progress_bar_drag_started() -> void:
	dragging = true
	conductor.pause()


func _on_progress_bar_value_changed(_value: float) -> void:
	if dragging:
		_update_labels()


func _on_progress_bar_drag_ended(_value_changed: bool) -> void:
	dragging = false
	conductor.play(progress_bar.value)


func _on_backward_pressed() -> void:
	seek(-5)


func _on_forward_pressed() -> void:
	seek(5)


func _on_play_puase_pressed() -> void:
	if conductor.playing:
		conductor.pause()
	else:
		conductor.unpause()
