extends Node

@export var input: GameInput
@export var conductor: Conductor
@export var tier_spawn: Marker2D
@export var game: Node2D
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
	var index := -1
	for t in tiers:
		index += 1
		if abs(diff) < t.get("threshold"):
			print("judge: ", t)
			# stats stuff update
			game.stats['score'] += t['score']
			if index == tiers.size() - 1:
				game.stats['combo'] = 0
				game.stats['misses'] += 1
				game.damage_health()
			else:
				game.stats['combo'] += 1
				if game.stats['max_combo'] < game.stats['combo']: game.stats['max_combo'] = game.stats['combo']
				game.stats['total_offset'] += diff
			if index == 0:
				game.stats['perfects'] += 1
			note_index += 1
			_spawn_tier(t["tier"], diff, t["color"])
			break

func _process(_delta: float) -> void:
	while note_index < notes.size() and notes[note_index]["time"] <= conductor.playback_pos - Settings.offset/1000.0 - miss_tier["threshold"]:
		var note = notes[note_index]
		var diff = conductor.playback_pos - Settings.offset/1000.0 - note["time"]
		_spawn_tier(miss_tier["tier"], diff, miss_tier["color"])
		game.damage_health()
		note_index += 1


func _spawn_tier(text: String, offset: float, color: Color) -> void:
	var t = tier.instantiate()
	t.set_text(text, offset)
	t.set_color(color)
	tier_spawn.add_child(t)
