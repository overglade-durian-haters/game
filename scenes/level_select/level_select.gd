extends Panel

const level_item = preload('res://scenes/level_select/level_item.tscn')
const level_card = preload('res://scenes/level_select/level_card.tscn')

var LEVELS = [
	"res://levels/metronome.zip",
	"res://levels/lullaby.zip"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i = 0
	for level in LEVELS:
		GameFile.load_level(level)
		var item = level_item.instantiate()
		item.set_txt(GameState.level['title'], GameState.level['author'])
		item.index = i
		item.data = GameState.level
		item.path = level
		%levelitems.add_child(item)
		
