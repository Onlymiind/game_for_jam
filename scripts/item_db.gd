extends Node

const item_texture_files: PackedStringArray = [
	"res://assets/1колье.png",
	"res://assets/1телефон.png",
	"res://assets/3маска.png",
	"res://assets/3помидорнытигр.png"
	]

var item_hitboxes: Array[PackedVector2Array]
var item_textures: Array[ImageTexture]

func _ready() -> void:
	var file: FileAccess = FileAccess.open(Constants.item_hitbox_path, FileAccess.READ)
	for i in range(item_texture_files.size()):
		item_hitboxes.append(file.get_var() as PackedVector2Array)
		var img: Image = Image.load_from_file(item_texture_files[i])
		item_textures.append(ImageTexture.create_from_image(img))

func get_item_count() -> int:
	return item_textures.size()
