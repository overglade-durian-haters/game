extends Node
class_name GameInput

signal hit


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("hit"):
		hit.emit()
