extends Button

@onready var card: Panel = $"/root/levelselect/VBoxContainer/HBoxContainer/level_card"
var data: Dictionary
var path: String
var index: int

func set_image(image: String) -> void:
	%icon.texture = ImageTexture.create_from_image(Image.load_from_file(image))
	%icon.visible = true
	print("set image good")

func set_txt(title: String, author: String) -> void:
	%title.text = title
	%author.text = author

func update_card() -> void:
	card.set_txt(data['title'], data['author'])
	if %icon.visible:
		card.set_image(GameState.image_path)
	else:
		card.clear_image()

func _on_button_up() -> void:
	GameFile.load_level(path)
	update_card()
