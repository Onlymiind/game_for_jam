@tool
extends EditorScript

func _run() -> void:
	generate_hitboxes()

func generate_hitboxes():
	var file: FileAccess = FileAccess.open(Constants.item_hitbox_path, FileAccess.WRITE)
	for path_idx in range(ItemDb.item_texture_files.size()):
		var image: Image = Image.load_from_file(ItemDb.item_texture_files[path_idx])
		var bitmap: BitMap = BitMap.new()
		bitmap.create_from_image_alpha(image)
		var size: Vector2 = bitmap.get_size()
		var polygon: PackedVector2Array = bitmap.opaque_to_polygons(Rect2i(Vector2i.ZERO, size))[0]
		for i in range(polygon.size()):
			polygon[i].x = polygon[i].x - size.x / 2
			polygon[i].y = polygon[i].y - size.y / 2
		file.store_var(polygon)
	file.close()
