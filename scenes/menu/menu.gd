extends Panel


func _on_play_pressed() -> void:
	SceneManager.change_scene("game")


func _on_quit_pressed() -> void:
	get_tree().quit()
