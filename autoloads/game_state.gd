extends Node

var level: Dictionary
var music_path: String = "res://assets/audio/calibration.wav"
var hand_tween_time: float = 0.05

var editor_count := 0


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
