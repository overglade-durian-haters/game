extends Node
class_name EditorHandsHandler

@export var conductor: Conductor
@export var bpm_input: Range
@export var edit_handler: Node

@export var container: VBoxContainer

const EditorHandScene = preload("res://scenes/leveL_editor/editor_hand/editor_hand.tscn")

var hands := []
var hand_map: Dictionary[int, EditorHand] = {}
var hands_events := []
var hands_event_index := 0
var last_event_time := 1e9

var next_id = 1


func _ready() -> void:
	call_deferred("_init_from_game_state")


func _init_from_game_state() -> void:
	var pending_hands: Dictionary[int, Dictionary] = {}
	var events = GameState.level.get("events", [])
	for event in events:
		match event["type"]:
			"spawn_hand":
				var id = int(event["id"])
				pending_hands[id] = {
					"id": id,
					"bpm": event["bpm"],
					"initial_offset": int(event["initial_offset"]),
					"stride": int(event["stride"]),
					"start_time": event["time"]
				}
				next_id = max(id+1, next_id)
			"remove_hand":
				var id = int(event["id"])
				var hand = pending_hands[id]
				if hand:
					pending_hands.erase(id)
					hand["end_time"] = event["time"]
					hands.append(hand)
	for id in pending_hands:
		var hand = pending_hands[id]
		hand["end_time"] = conductor.audio.get_length()
		hands.append(hand)
	update_children()


func _process(_delta: float) -> void:
	var pos = conductor.playback_pos
	if pos < last_event_time:
		hands_event_index = 0
		last_event_time = 0
		for node in hand_map.values():
			node.set_highlight(false)
	while hands_event_index < hands_events.size() and hands_events[hands_event_index]["time"] <= pos:
		var event = hands_events[hands_event_index]
		match event["type"]:
			"start":
				var node = hand_map[event["hand_id"]]
				if node:
					node.set_highlight(true)
			"end":
				var node = hand_map[event["hand_id"]]
				if node:
					node.set_highlight(false)
		hands_event_index += 1
		last_event_time = event["time"]


func update_children():
	for child in container.get_children():
		if child is EditorHand:
			child.queue_free()
	hand_map.clear()
	hands_events.clear()
	
	hands.sort_custom(_compare_hands)
	
	for hand in hands:
		var child = EditorHandScene.instantiate()
		child.id = hand["id"]
		child.start_time = hand["start_time"]
		child.end_time = hand["end_time"]
		child.bpm = hand["bpm"]
		child.stride = hand["stride"]
		child.initial_offset = hand["initial_offset"]
		child.edit.connect(_on_edit_hand)
		child.delete.connect(_on_delete_hand)
		container.add_child(child)
		hand_map[hand["id"]] = child
		hands_events.append({ "type": "start", "hand_id": hand["id"], "time": hand["start_time"] })
		hands_events.append({ "type": "end", "hand_id": hand["id"], "time": hand["end_time"] })
		var beat = 0
		var time = hand["start_time"] + 60.0/hand["bpm"]
		while time < hand["end_time"]:
			hands_events.append({ "type": "tick", "hand_id": hand["id"], "time": time })
			beat += 1
			time = hand["start_time"] + beat*60.0/hand["bpm"]
	hands_events.sort_custom(func(a, b): return a["time"] < b["time"])
	
	last_event_time = 1e9


func _on_add_hand_pressed() -> void:
	var start = _snap_time()
	var end = start + 240.0 / bpm_input.value
	var hand = {
		"id": next_id,
		"start_time": start,
		"end_time": end,
		"bpm": bpm_input.value,
		"stride": 5,
		"initial_offset": 0
	}
	hands.append(hand)
	update_children()
	next_id += 1


func _on_edit_hand(hand: EditorHand):
	var index = hands.find_custom(func(h): return h["id"] == hand.id)
	if index >= 0:
		edit_handler.open(hands[index])


func _on_delete_hand(hand: EditorHand):
	hands = hands.filter(func(h): return h["id"] != hand.id)
	update_children()


func _on_hand_edited() -> void:
	update_children()


func _compare_hands(a, b):
	if a["start_time"] < b["start_time"]:
		return true
	return a["end_time"] < b["end_time"]


func _snap_time(time: float = -1):
	if time < 0:
		time = conductor.playback_pos
	var bpm = bpm_input.value
	var beat = bpm * time / 60.0
	return roundf(beat) * 60.0 / bpm
