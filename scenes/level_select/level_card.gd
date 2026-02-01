extends Panel

func _ready() -> void:
	%icon.visible = false

func set_image(image: String) -> void:
	%icon.texture = image
	%icon.visible = true

func clear_image() -> void:
	%icon.visible = false

func set_txt(title: String, author: String) -> void:
	%title.text = title
	%author.text = author

# TODO set level data function
# enable button when level data is present
