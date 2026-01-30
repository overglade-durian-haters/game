extends Panel


func _on_play_pressed() -> void:
	GameState.level = {
		"title": "",
		"events": [
			{
				"type": "spawn_hand",
				"time": 0.0,
				"id": 1,
				"bpm": 120.0,
				"stride": 5,
				"initial_offset": 0
			},
			{
				"type": "remove_hand",
				"time": 4.0,
				"id": 1
			}
		]
	}
	GameState.music_path = "res://assets/audio/calibration.wav"
	SceneManager.change_scene("game")


func _on_quit_pressed() -> void:
	get_tree().quit()
