extends Button

var data: Dictionary
var index: int

func _ready() -> void:
	%icon.visible = false

func set_image(image: String) -> void:
	%icon.texture = image
	%icon.visible = true

func set_txt(title: String, author: String) -> void:
	%title.text = title
	%author.text = author
