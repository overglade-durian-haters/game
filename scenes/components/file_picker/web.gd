extends Node2D

@export var filter = ".wav,.wave"

@onready var ui = $CanvasLayer

var _input_change_cb = JavaScriptBridge.create_callback(_on_input_change)
var _got_buffer_cb = JavaScriptBridge.create_callback(_on_got_buffer)

var _file_name: String = "unknown.bin"

signal selected(path: String)
signal cancelled


func pick():
	ui.show()
	var document = JavaScriptBridge.get_interface("document")
	var input = document.createElement("input")
	input.type = 'file'
	input.accept = filter
	input.onchange = _input_change_cb
	input.click()


func _on_input_change(arguments: Array):
	var event = arguments[0]
	var files = event.target.files
	if files.length == 0:
		return
	var file = files[0]
	_file_name = file.name
	file.arrayBuffer().then(_got_buffer_cb)


func _on_got_buffer(arguments: Array):
	var buffer = arguments[0]
	var data = JavaScriptBridge.js_buffer_to_packed_byte_array(buffer)
	
	var path = "user://" + _file_name
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_buffer(data)
	file.close()
	ui.hide()
	selected.emit(path)


func _on_cancel() -> void:
	ui.hide()
	cancelled.emit()
