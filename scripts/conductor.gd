extends AudioStreamPlayer
class_name Conductor

@export var audio: AudioStream

signal audio_changed(audio: AudioStream)

var playback_pos: float  # seconds


func _ready() -> void:
	if audio:
		set_audio(audio)


func set_audio(new_audio: AudioStream):
	audio = new_audio
	
	stream = AudioStreamSynchronized.new()
	stream.stream_count = 1
	stream.set_sync_stream(0, new_audio)
	
	stop()
	
	audio_changed.emit(audio)


func _process(_delta: float) -> void:
	playback_pos = get_playback_position()


func pause():
	stream_paused = true


func unpause():
	if stream_paused:
		stream_paused = false
	elif not playing:
		play()


func get_state():
	print(playing, " ", stream_paused)
	if playing:
		return 'playing'
	if stream_paused:
		return 'paused'
	return 'stopped'
