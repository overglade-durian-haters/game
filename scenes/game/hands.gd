extends Node2D
class_name GameHands

@export var conductor: Conductor

@export var radius: float = 150

var hands: Dictionary[int, GameHand] = {}
var tick_count: Dictionary[int, int] = {}


func _draw():
	draw_circle(Vector2.ZERO, radius, Color.WHITE, false, 5)
	for i in range(12):
		var direction = Vector2.from_angle(i * PI / 6)
		draw_line(direction * radius, direction * radius * 0.95, Color.WHITE, 3)


func process():
	var pos = conductor.playback_pos
	for id in tick_count:
		var hand = hands[id]
		var next_tick = hand.time + 60 / hand.bpm * tick_count[id]
		print(id, " ", next_tick)
		if pos >= next_tick:
			hands[id].tick()
			tick_count[id] += 1


func spawn_hand(event: Dictionary):
	var id = event["id"]
	var hand = GameHand.new()
	hand.bpm = event["bpm"]
	hand.stride = event["stride"]
	hand.initial_offset = event["initial_offset"]
	hand.time = event["time"]
	add_child(hand)
	hands[id] = hand
	tick_count[id] = 0


func modify_hand(event: Dictionary):
	var id = event["id"]
	var hand = hands[id]
	if not hand:
		return
	hand.bpm = event["bpm"]
	hand.stride = event["stride"]
	hand.time = event["time"]
	tick_count[id] = 0


func remove_hand(id: int):
	var hand = hands[id]
	if hand:
		hand.queue_free()
		hands.erase(id)
		tick_count.erase(id)
