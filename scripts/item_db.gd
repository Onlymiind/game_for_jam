extends Node

const item_texture_files: PackedStringArray = [
	"res://assets/1-колье.png",
	"res://assets/1-телефон.png",
	"res://assets/2-маска.png",
	"res://assets/3-помидорнытигр.png",
	"res://assets/4-телевизор.png",
	"res://assets/3-торшер.png"
	]

const item_names: PackedStringArray = [
	"Necklace",
	"Phone",
	"Mask",
	"Weird vase",
	"TV",
	"Floor lamp",
]

const item_scores: PackedInt32Array = [
	1500,
	2000,
	4000,
	4500,
	8000,
	3500
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
