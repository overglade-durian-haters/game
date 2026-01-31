extends Node2D
class_name FilePicker

@export var filter: String = "*.wav,*.wave;.WAV Files;audio/vnd.wav,audio/vnd.wave,audio.wav,audio.wave"

signal selected(path: String)
signal cancelled


func _ready():
	$Desktop/FileDialog.filters = PackedStringArray([filter])
	$Web.filter = filter.split(";")[2]


func pick():
	if OS.has_feature("web"):
		$Web.pick()
	else:
		$Desktop.pick()


func _on_selected(path: String):
	selected.emit(path)


func _on_cancelled():
	cancelled.emit()
