extends Node

@export var input: GameInput
@export var conductor: Conductor
@export var tier_spawn: Marker2D
const tier := preload("res://scenes/game/tier.tscn")

@onready var notes: Array = GameState.level["notes"].duplicate()
var note_index = 0

var tiers: Array[Dictionary] = [
	_new_bracket("Perfect", 0.016, 100, _rgb_to_color01(216, 184, 255)),
	_new_bracket("Great", 0.037, 67, _rgb_to_color01(189, 213, 255)),
	_new_bracket("Good", 0.055, 33, _rgb_to_color01(200, 255, 229)),
	_new_bracket("Okay", 0.095, 12, _rgb_to_color01(255, 245, 189)),
	_new_bracket("Miss", 0.250, 0, _rgb_to_color01(210, 210, 210))
]
var miss_tier = tiers[tiers.size() - 1]

func _rgb_to_color01(r: float, g: float, b: float) -> Color:
	return Color(r/255, g/255, b/255, 1.0)

func _new_bracket(n: String, t: float, s: int, c: Color) -> Dictionary:
	return {
		"tier": n,
		"threshold": t,
		"score": s,
		"color": c
	}

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
