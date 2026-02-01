extends Node

@export var conductor: Conductor
@export var bpm_input: Range
@export var edit_handler: Node

@export var container: VBoxContainer

const EditorHandScene = preload("res://scenes/leveL_editor/editor_hand/editor_hand.tscn")

var hands := []
var hands_events := []

var next_id = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # TODO: get 


func update_children():
	for child in container.get_children():
		if child is EditorHand:
			child.queue_free()
	hands.sort_custom(_compare_hands)
	for hand in hands:
		var child = EditorHandScene.instantiate()
		child.id = hand["id"]
		child.start_time = hand["start_time"]
		child.end_time = hand["end_time"]
		child.bpm = hand["bpm"]
		child.stride = hand["stride"]
		child.edit.connect(_on_edit_hand)
		child.delete.connect(_on_delete_hand)
		container.add_child(child)


func _on_add_hand_pressed() -> void:
	var start = _snap_time()
	var end = start + 240.0 / bpm_input.value
	var hand = { "id": next_id, "start_time": start, "end_time": end, "bpm": bpm_input.value, "stride": 5 }
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
