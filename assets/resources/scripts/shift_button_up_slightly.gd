extends Button

var distance := 2.0
var duration := 0.3
var tween: Tween

var origin: float
var up: float

func _ready() -> void:
	await get_tree().process_frame
	origin = position.y
	up = origin - distance

func _on_mouse_entered() -> void:
	_up()

func _on_mouse_exited() -> void:
	_dn()

func _on_button_down() -> void:
	_dn()

func _up() -> void:
	if tween: tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", up, duration)

func _dn() -> void:
	if tween: tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", origin, duration)
