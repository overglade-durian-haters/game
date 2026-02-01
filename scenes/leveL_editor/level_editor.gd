extends Control

@export var conductor: Conductor

@export var music_picker: FilePicker


func _ready() -> void:
	conductor.set_audio(AudioStreamWAV.load_from_file(GameState.music_path))
	conductor.pause()


func _on_change_music_pressed() -> void:
	music_picker.pick()


func _on_music_picker_selected(path: String) -> void:
	GameState.music_path = path
	get_tree().reload_current_scene()


func _on_back_pressed() -> void:
	SceneManager.change_scene("menu")
