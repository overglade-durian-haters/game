extends Node

@export var input: GameInput
@export var conductor: Conductor
@export var tier_spawn: Marker2D
const tier := preload("res://scenes/game/tier.tscn")

@onready var notes: Array = GameState.level["notes"].duplicate()
var note_index = 0

var tiers := GameState.tiers
var miss_tier = tiers[tiers.size() - 1]

func _ready() -> void:
	input.hit.connect(_on_hit)


func _on_hit() -> void:
	if note_index >= notes.size():
		return
	var note = notes[note_index]
	var diff = conductor.playback_pos - Settings.offset/1000.0 - note["time"]
	print(note, " ", diff, " ", note_index)
	var index := 0
	for t in tiers:
		index += 1
		if abs(diff) < t.get("threshold"):
			print("judge: ", t)
			_spawn_tier(t["tier"], diff, t["color"])
			# stats stuff update
			GameState.stats['score'] += t['score']
			if index == tiers.size() - 1:
				GameState.stats['combo'] = 0
				GameState.stats['misses'] += 1
			else:
				GameState.stats['combo'] += 1
				if GameState.stats['max_combo'] < GameState.stats['combo']: GameState.stats['max_combo'] = GameState.stats['combo']
				GameState.stats['total_offset'] += diff
			if index == 0:
				GameState.stats['perfects'] += 1
			note_index += 1
			break

func _process(_delta: float) -> void:
	while note_index < notes.size() and notes[note_index]["time"] <= conductor.playback_pos - Settings.offset/1000.0 - miss_tier["threshold"]:
		var note = notes[note_index]
		var diff = conductor.playback_pos - Settings.offset/1000.0 - note["time"]
		_spawn_tier(miss_tier["tier"], diff, miss_tier["color"])
		note_index += 1


func _spawn_tier(text: String, offset: float, color: Color) -> void:
	var t = tier.instantiate()
	t.set_text(text, offset)
	t.set_color(color)
	tier_spawn.add_child(t)
