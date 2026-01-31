extends Node

var level: Dictionary
var music_path: String

var stats: Dictionary = {
	'score' = 0,
	'max_combo' = 0,
	'perfects' = 0,
	'combo' = 0,
	'misses' = 0,
	'total_offset' = 0.0,
	'num_notes' = 0,
	'avg_offset' = 0.0,
	'finished' = false,
	'percentage_notes' = 0.0,
	'percentage_score' = 0.0,
	'percentage_overall' = 0.0
}
