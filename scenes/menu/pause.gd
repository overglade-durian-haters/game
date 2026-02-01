extends Panel
class_name PauseMenu

var duration := 0.2

var tween: Tween

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			unpause()
		else:
			pause()


func pause() -> void:
	if $"../countdown".counting:
		return
	print("pause")
	get_tree().paused = true
	position.x = -size.x
	visible = true
	if tween: tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:x", 0, duration)

func unpause() -> void:
	if $"../countdown".counting:
		return
	print("unpause")
	#get_tree().paused = false
	if tween: tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:x", -size.x, duration)
	$"../countdown".call("start_countdown")
	#tween.tween_property(self, "visible", false, 1)


func _on_resume_pressed() -> void:
	unpause()


func _on_menu_pressed() -> void:
	get_tree().paused = false
	$"../..".end(false)
