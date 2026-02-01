extends Node


func load_level(path: String):
	var reader = ZIPReader.new()
	var err = reader.open(path)
	if err != OK:
		return err
	
	var level = JSON.parse_string(reader.read_file("level.json").get_string_from_utf8())
	var music_data = reader.read_file("level.wav")
	var music_file = FileAccess.open("user://tmp.wav", FileAccess.WRITE)
	music_file.store_buffer(music_data)
	music_file.close()
	
	GameState.level = level
	GameState.music_path = "user://tmp.wav"
	
	return OK


func save_level(path: String):
	var writer = ZIPPacker.new()
	var err = writer.open(path)
	if err != OK:
		return err
	
	writer.start_file("level.json")
	writer.write_file(JSON.stringify(GameState.level).to_utf8_buffer())
	writer.close_file()
	
	writer.start_file("level.wav")
	writer.write_file(FileAccess.get_file_as_bytes(GameState.music_path))
	writer.close_file()
	
	writer.close()
	
	return OK
