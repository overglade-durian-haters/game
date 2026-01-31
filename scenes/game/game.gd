extends Node2D

@export var conductor: Conductor
@export var hands: GameHands
@export var pause_menu: PauseMenu

@onready var title = GameState.level["title"]
@onready var events = GameState.level["events"]

var event_index = 0


func _ready() -> void:
	conductor.volume_linear = Settings.master_volume * Settings.music_volume
	var stream = AudioStreamWAV.load_from_file(GameState.music_path)
	conductor.set_audio(stream)
	conductor.unpause()


func _process(_delta: float) -> void:
	var pos = conductor.playback_pos - Settings.offset/1000.0
	while event_index < events.size() and pos > events[event_index]["time"]:
		var event = events[event_index]
		print("EVENT ", event)
		match event["type"]:
			"spawn_hand":
				hands.spawn_hand(event)
			"modify_hand":
				hands.modify_hand(event)
			"remove_hand":
				hands.remove_hand(event["id"])
		event_index += 1
	hands.process()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			pause_menu.unpause()
		else:
			pause_menu.pause()
