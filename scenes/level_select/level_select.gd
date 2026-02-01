extends Panel

@export var level_item = preload('res://scenes/level_select/level_item.tscn')
@export var level_card = preload('res://scenes/level_select/level_card.tscn')

var LEVELS = [ ## 
	_new_level("")
	_new_level("Lullaby", "me", "res://levels/lullaby.zip")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i = 0
	for level in LEVELS:
		var item = level_item.instantiate()
		item.set_txt(level['name'], level['author'])
		item.index = i
		%levelitems.add_child(item)
		

func _level_selected(path: String):
	GameState.selected_level = path
	get_tree().change_scene_to_file("res://game/game.tscn")

func _new_level(n: String, a: String, p: String) -> Dictionary:
	return {
		'name': n,
		'author': a,
		'path': p
	}
