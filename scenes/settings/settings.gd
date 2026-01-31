extends Panel

@export var master: Range
@export var master_label: Label
@export var music: Range
@export var music_label: Label
@export var hitsound: Range
@export var hitsound_label: Label
@export var offset: Range


func _ready() -> void:
	print("update ", Settings.music_volume)
	_update_ranges()
	_update_labels()


func _on_value_changed(_value: float) -> void:
	print("chang??", _value)
	call_deferred("_update_settings")


func _update_settings():
	Settings.master_volume = master.value
	Settings.music_volume = music.value
	Settings.hitsound_volume = hitsound.value
	Settings.offset = roundi(offset.value)
	Settings.save()
	_update_labels()


func _update_ranges():
	master.value = Settings.master_volume
	music.value = Settings.music_volume
	hitsound.value = Settings.hitsound_volume
	offset.value = Settings.offset


func _update_labels():
	master_label.text = str(roundi(master.value * 100)) + "%"
	music_label.text = str(roundi(music.value * 100)) + "%"
	hitsound_label.text = str(roundi(hitsound.value * 100)) + "%"


func _on_back_pressed() -> void:
	SceneManager.change_scene("menu")
