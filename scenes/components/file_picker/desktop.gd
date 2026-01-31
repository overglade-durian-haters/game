extends Node2D

signal selected(path: String)
signal cancelled


func pick():
	$FileDialog.show()
	$Panel.show()


func _on_file_selected(path: String) -> void:
	$Panel.hide()
	selected.emit(path)


func _on_cancelled():
	$Panel.hide()
	cancelled.emit()
