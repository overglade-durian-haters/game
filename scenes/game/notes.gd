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
	var diff = note["time"] - conductor.playback_pos
	for t in tiers:
		if abs(diff) < t.get("threshold"):
			_spawn_tier(t["tier"], diff, t["color"])
			break
	note_index += 1

func _spawn_tier(text: String, offset: float, color: Color) -> void:
	var t = tier.instantiate()
	#t.fade_time = 0.25
	#t.travel_dist = 20.0
	t.set_text(text, offset)
	t.set_color(color)
	tier_spawn.add_child(t)
