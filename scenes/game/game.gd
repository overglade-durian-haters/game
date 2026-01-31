extends Node2D

@export var conductor: Conductor
@export var hands: GameHands
@export var pause_menu: PauseMenu

@onready var title = GameState.level["title"]
@onready var events = GameState.level["events"]

var event_index = 0


func _ready() -> void:
	GameState.stats['num_notes'] = events.size()
	conductor.volume_linear = Settings.master_volume * Settings.music_volume
	var stream = AudioStreamWAV.load_from_file(GameState.music_path)
	conductor.set_audio(stream)
	conductor.unpause()


func _process(_delta: float) -> void:
	if not conductor.playing:
		end(true)
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

func end(finished: bool) -> void:
	if finished:
		GameState.stats['finished'] = finished
		GameState.stats['avg_offset'] = GameState.stats['total_offset'] / (GameState.stats['num_notes'] - GameState.stats['misses'])
		GameState.stats['percentage_notes'] = (GameState.stats['num_notes'] - GameState.stats['misses']) / float(GameState.stats['num_notes'])
		GameState.stats['percentage_score'] = GameState.stats['score'] / float(GameState.tiers[0]['score'] * GameState.stats['num_notes'])
		GameState.stats['percentage_overall'] = GameState.stats['percentage_notes'] * 0.75 + GameState.stats['percentage_score'] * 0.25
		GameState.stats['percentage_overall'] = clamp(GameState.stats['percentage_overall'], 0.0, 1.0)
		print(GameState.stats)
		$menus/summary.set_text(GameState.stats['percentage_overall'], GameState.stats['max_combo'], GameState.stats['combo'], GameState.stats['misses'])
		$menus/summary.enter()
	else:
		SceneManager.change_scene("menu")

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			pause_menu.unpause()
		else:
			pause_menu.pause()
