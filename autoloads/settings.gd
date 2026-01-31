extends Node

const FILE_PATH = "user://settings.cfg"
var config = ConfigFile.new()

var offset = 0  # ms
var master_volume = 1.0
var music_volume = 1.0
var hitsound_volume = 1.0


func _ready() -> void:
	var err = config.load(FILE_PATH)
	if err != OK:
		push_warning("Error ", err, " loading config file")
		DirAccess.remove_absolute(FILE_PATH)
	
	offset = config.get_value("gameplay", "offset", offset)
	master_volume = config.get_value("audio", "master_volume", master_volume)
	music_volume = config.get_value("audio", "music_volume", music_volume)
	hitsound_volume = config.get_value("audio", "hitsound_volume", hitsound_volume)
	print("initial load ", music_volume)


func save():
	print(music_volume)
	config.set_value("gameplay", "offset", offset)
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "hitsound_volume", hitsound_volume)
	config.save(FILE_PATH)
