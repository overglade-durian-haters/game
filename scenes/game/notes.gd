extends Node

@export var input: GameInput
@export var conductor: Conductor

@onready var notes: Array = GameState.level["notes"].duplicate()
var note_index = 0


func _ready() -> void:
	input.hit.connect(_on_hit)


func _on_hit() -> void:
	if note_index >= notes.size():
		return
	var note = notes[note_index]
	var diff = note["time"] - conductor.playback_pos
	if abs(diff) < 0.1:
		print("hit")
	else:
		print("miss")
	note_index += 1
