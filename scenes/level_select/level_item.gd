extends Button

@onready var card: Panel = $"/root/levelselect/VBoxContainer/HBoxContainer/level_card"
var data: Dictionary
var path: String
var index: int

func _ready() -> void:
	%icon.visible = false

func set_image(image: String) -> void:
	%icon.texture = image
	%icon.visible = true

func set_txt(title: String, author: String) -> void:
	%title.text = title
	%author.text = author

func update_card() -> void:
	card.set_txt(data['title'], data['author'])
	if %icon.visible:
		card.set_image(data['image'])

func _on_button_up() -> void:
	update_card()
	GameFile.load_level(path)
