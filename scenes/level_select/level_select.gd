extends Panel

var LEVELS = [
	_new_level("Lullaby", "me", "res://levels/lullaby.zip")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for level in LEVELS:
		%levelitems

func _level_selected(path: String):
	GameState.selected_level = path
	get_tree().change_scene_to_file("res://game/game.tscn")

func _new_level(n: String, a: String, p: String) -> Dictionary:
	return {
		'name': n,
		'author': a,
		'path': p
	}
