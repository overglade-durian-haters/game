extends Node2D
class_name GameHand

@onready var hands = get_parent()

## number of ticks per minute
@export var bpm: float = 60.0
## length of each tick, unit = 1/60 rev
@export var stride: int = 5
## starting position, unit = 1/60 rev
@export var initial_offset: int = 0
## starting time, in seconds
@export var time: float = 0.0

@export var color: Color = Color.WHITE
@export var width: float = 2.0
## fraction of circle radius
@export var length: float = 0.8

@onready var current_tick: int = initial_offset


func _draw():
	var from = Vector2.ZERO
	var to = Vector2(0, -hands.radius * length)
	draw_line(from, to, color, width)


func tick():
	current_tick = current_tick + stride
	var rot_deg = 6 * current_tick
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation_degrees", rot_deg, 0.2)
