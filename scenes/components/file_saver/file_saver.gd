extends Control

@onready var file_dialog = $Desktop
@onready var block_layer = $Block

signal completed
signal canceled

var _saving_buffer: PackedByteArray


func save(data: PackedByteArray, filename: String, mime: String, label: String = "File"):
	if OS.has_feature("web"):
		JavaScriptBridge.download_buffer(data, filename, mime)
		completed.emit()
	else:
		_saving_buffer = data
		var extension = "*" if "." not in filename else ("*." + filename.rsplit(".", true, 1)[1])
		var filter = extension + ";" + label + ";" + mime
		file_dialog.filters = PackedStringArray([filter])
		file_dialog.show()
		block_layer.show()


func _on_file_selected(path: String) -> void:
	block_layer.hide()
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_buffer(_saving_buffer)
	file.close()
	completed.emit()


func _on_file_canceled() -> void:
	block_layer.hide()
	canceled.emit()
