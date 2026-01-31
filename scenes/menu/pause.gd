extends Panel

var duration := 0.2

var tween: Tween

func pause() -> void:
	position.x = -size.x
	visible = true
	tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:x", 0, duration)

func unpause() -> void:
	if tween: tween.kill()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:x", -size.x, duration)
	visible = false
