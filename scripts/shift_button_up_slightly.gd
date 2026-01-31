extends Button

var distance := 2.0
var duration := 0.4
var tween: Tween

var origin: float
var up: float

func _ready() -> void:
	#print("ready ", name)
	await get_tree().process_frame
	#print("ready x2 ", name, " ", self.position.y)
	origin = self.position.y
	up = origin - distance
	#print(name, " ", origin, " ", up)

func _on_mouse_entered() -> void:
	#print("enter ", name)
	_up()

func _on_mouse_exited() -> void:
	#print("exit ", name)
	_dn()

func _on_button_down() -> void:
	#print("down ", name)
	_dn()

func _up() -> void:
	if tween: tween.kill()
	#tween = create_tween()
	#tween.set_trans(Tween.TRANS_EXPO)
	#tween.set_ease(Tween.EASE_OUT)
	#tween.tween_property(self, "position:y", up, duration)

func _dn() -> void:
	if tween: tween.kill()
	#tween = create_tween()
	#tween.set_trans(Tween.TRANS_EXPO)
	#tween.set_ease(Tween.EASE_OUT)
	#tween.tween_property(self, "position:y", origin, duration)
