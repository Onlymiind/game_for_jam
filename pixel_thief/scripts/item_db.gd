extends Node

const item_texture_files: PackedStringArray = [
	"res://assets/1-колье.png",
	"res://assets/1-телефон.png",
	"res://assets/2-маска.png",
	"res://assets/3-помидорнытигр.png",
	"res://assets/4-телевизор.png",
	"res://assets/3-торшер.png",
	"res://assets/1-флакон дорогих духов.png",
	"res://assets/3-люксовый свитер.png",
	"res://assets/4-зеркало.png",
	"res://assets/4-ковер.png",
	]

const item_names: PackedStringArray = [
	"Necklace",
	"Phone",
	"Mask",
	"Weird vase",
	"TV",
	"Floor lamp",
	"Perfume",
	"Sweater",
	"Mirror",
	"Carpet",
]

const item_scores: PackedInt32Array = [
	1500,
	2000,
	4000,
	4500,
	8000,
	3500,
	1000,
	800,
	5000,
	2600,
]

var item_hitboxes: Array[PackedVector2Array]
const item_textures: Array[CompressedTexture2D] = [
	preload("res://assets/1-колье.png"),
	preload("res://assets/1-телефон.png"),
	preload("res://assets/2-маска.png"),
	preload("res://assets/3-помидорнытигр.png"),
	preload("res://assets/4-телевизор.png"),
	preload("res://assets/3-торшер.png"),
	preload("res://assets/1-флакон дорогих духов.png"),
	preload("res://assets/3-люксовый свитер.png"),
	preload("res://assets/4-зеркало.png"),
	preload("res://assets/4-ковер.png"),
]

func _ready() -> void:
	var file: FileAccess = FileAccess.open(Constants.item_hitbox_path, FileAccess.READ)
	for i in range(item_textures.size()):
		item_hitboxes.append(file.get_var() as PackedVector2Array)

func get_item_count() -> int:
	return item_textures.size()
