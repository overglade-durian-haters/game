extends Control

func start_countdown(): 
	visible = true
	_countdown(0)
	
func _countdown(idx : int):
	var tween = get_tree().create_tween()
	
	var displayed_node = get_child(idx)
	var start_pos = displayed_node.position
	displayed_node.visible = true
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(displayed_node, "position", displayed_node.position + Vector2.UP*10, 0.5).set_ease(Tween.EASE_OUT)
	await tween.finished
	displayed_node.visible = false
	displayed_node.position = start_pos
	print(get_child_count(), " ", idx+1)
	if idx+1<get_child_count():
		_countdown(idx+1)
	else:
		get_tree().paused = false
		visible = false

	
