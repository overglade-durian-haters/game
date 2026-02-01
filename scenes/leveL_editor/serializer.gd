extends Node

@export var hands: EditorHandsHandler

@export var level_saver: FileSaver
@export var level_loader: FilePicker


func serialize():
	var positions: Dictionary[int, int] = {}
	var events = []
	var notes = []
	
	var hand_map = {}
	for hand in hands.hands:
		hand_map[hand["id"]] = hand
	
	print(hands.hands_events)
	for event in hands.hands_events:
		match event["type"]:
			"start":
				var hand = hand_map[event["hand_id"]]
				events.append({
					"type": "spawn_hand",
					"time": event["time"],
					"id": event["hand_id"],
					"bpm": hand["bpm"],
					"stride": hand["stride"],
					"initial_offset": hand["initial_offset"]
				})
				positions[event["hand_id"]] = int(hand["initial_offset"])
			"end":
				events.append({
					"type": "remove_hand",
					"time": event["time"],
					"id": event["hand_id"]
				})
				positions.erase(event["hand_id"])
			"tick":
				var hand = hand_map[event["hand_id"]]
				positions[hand["id"]] = ((int(positions[hand["id"]] + hand["stride"]) % 60) + 60) % 60
				print("PP: ", positions)
				for other in positions:
					if other != hand["id"] and positions[other] == positions[hand["id"]]:
						notes.append({ "id": notes.size()+1, "time": event["time"] })
						break
	
	return {
		"title": "song",
		"events": events,
		"notes": notes
	}


func _on_save_pressed() -> void:
	GameState.level = serialize()
	GameFile.save_level("user://tmp.zip")
	var data = FileAccess.get_file_as_bytes("user://tmp.zip")
	level_saver.save(data, "level.zip", "application/zip", "Game file")


func _on_load_pressed() -> void:
	level_loader.pick()


func _on_level_loader_selected(path: String) -> void:
	GameFile.load_level(path)
	get_tree().reload_current_scene()
