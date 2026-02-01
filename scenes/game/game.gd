extends Node2D

@export var conductor: Conductor
@export var hands: GameHands
@export var pause_menu: PauseMenu

@onready var title = GameState.level["title"]
@onready var events = GameState.level["events"]

#region Health Variables
@export var max_health := 100
var health : float:
	set(value):
		health_modified(value, value-health)
		health = clampf(max_health, 0, value)
		if value <= 0:
			game_failed()
@export var health_ui : ProgressBar

@export var health_regen := 5.0
@export var health_regen_cooldown := 1.0
var curr_health_regen_cooldown = 0

@export var damage_amount := 0.0
#endregion

var event_index = 0
var ended: bool

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

func _ready() -> void:
	%fadeout.size.y = get_viewport().size.y
	%fadeout.visible = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(%fadeout, "size:y", 0, 0.2)
	tween.tween_callback(_hide_fadeout)
	stats['num_notes'] = events.size() + 1
	conductor.volume_linear = Settings.master_volume * Settings.music_volume
	var stream = AudioStreamWAV.load_from_file(GameState.music_path)
	conductor.set_audio(stream)
	conductor.unpause()

	#Health setup
	health_ui.max_value = max_health
	health = max_health

func _hide_fadeout() -> void: %fadeout.visible = false

func _process(delta: float) -> void:
	if ended:
		return
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

	#health stuff
	print(curr_health_regen_cooldown)
	if curr_health_regen_cooldown > 0.0:
		curr_health_regen_cooldown -= delta
	else:
		health += health_regen*delta



func end(finished: bool) -> void:
	if finished:
		stats['finished'] = finished
		stats['avg_offset'] = stats['total_offset'] / (stats['num_notes'] - stats['misses'])
		stats['percentage_notes'] = (stats['num_notes'] - stats['misses']) / float(stats['num_notes'])
		stats['percentage_score'] = stats['score'] / float(GameState.tiers[0]['score'] * stats['num_notes'])
		stats['percentage_overall'] = stats['percentage_notes'] * 0.75 + stats['percentage_score'] * 0.25
		#stats['percentage_overall'] = stats['percentage_notes'] * 0.04 + stats['percentage_score'] * 0.01 + 0.95
		stats['percentage_overall'] = clamp(stats['percentage_overall'], 0.0, 1.0)
		print("final stats:", stats)
		$menus/summary.set_text(stats['percentage_overall'], stats['max_combo'], stats['combo'], stats['misses'])
		$menus/summary.enter()
		if stats['percentage_overall'] > 0.925:
			$confetti.emitting = true
			$confetti2.emitting = true
	else:
		var size = get_viewport().get_visible_rect().size.y
		%fadeout.size.y = 0
		%fadeout.visible = true
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_EXPO)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(%fadeout, "size:y", size, 0.2)
		await tween.finished
		if GameState.editor_count:
			GameState.editor_count -= 1
			SceneManager.change_scene("level_editor")
		else:
			SceneManager.change_scene("menu")
	ended = true

func health_modified(val: float, delta : float):
	health_ui.value = val
	if delta < 0:
		print("aeraeaeaerae")
		curr_health_regen_cooldown = health_regen_cooldown

func damage_health():
	print("damaged!")
	health -= damage_amount

func game_failed():
	var tween := create_tween()
	tween.tween_property(Engine, "time_scale", 0.01, 0.25)
	tween.tween_callback(func():
		ended = true
		Engine.time_scale = 1
		$Conductor.pause()
		$menus/summary.set_text(stats['percentage_overall'], stats['max_combo'], stats['combo'], stats['misses'], true)
		$menus/summary.enter()
	)
	##TODO: Implement Game Failed UI
