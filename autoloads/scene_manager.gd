extends Node

const SCENES = {
	"game": "res://scenes/game/game.tscn",
	"menu": "res://scenes/menu/menu.tscn",
	"settings": "res://scenes/settings/settings.tscn",
	"level_editor": "res://scenes/leveL_editor/level_editor.tscn"
}


func change_scene(to: String):
	if SCENES.has(to):
		get_tree().change_scene_to_file(SCENES[to])
	else:
		print("failed to change to nonexistant theme")
