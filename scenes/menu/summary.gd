extends Panel

var duration = 1.5

func _on_menubutton_button_up() -> void:
	SceneManager.change_scene("menu")

func enter() -> void:
	global_position.y = -size.y
	self.visible = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position:y", 136, duration)

func set_text(percentage01: float, mcombo: int, combo: int, misses: int) -> void:
	%percentage.text = str(snapped(percentage01 * 100, 0.01)) + '%'
	%mcombo.text = str(mcombo)
	%combo.text = str(combo)
	%misses.text = str(misses)
