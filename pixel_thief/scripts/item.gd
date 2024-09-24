class_name Item extends Area2D

@onready var sprite: Sprite2D = $sprite
@onready var collision: CollisionPolygon2D = $collision
@onready var outline: Polygon2D = $outline
@onready var outline_animation: AnimationPlayer = $outline_animation

var current_id: int

func get_bounding_box() -> Rect2:
	var bounding_box: Rect2 = sprite.get_rect()
	if abs(rotation - PI / 2) < 1e-3 || abs(rotation - 3 * PI / 2) < 1e-3:
		var x: float = bounding_box.size.x
		bounding_box.size.x = bounding_box.size.y
		bounding_box.size.y = x
	bounding_box.position = sprite.global_position - bounding_box.size / 2
	return bounding_box

func set_active() -> void:
	outline_animation.play("blink")
	z_index = 16

func set_inactive() -> void:
	outline_animation.stop()
	z_index = 0

func set_intersecting_color() -> void:
	outline.color.r = 255

func set_not_intersecting_color() -> void:
	outline.color.r = outline.color.g

func set_id(id: int) -> void:
	if id < 0 || id >= ItemDb.get_item_count():
		printerr("failed to set id on object ", self, ": item id ", id, " out of bounds")
		return
	sprite.texture = ItemDb.item_textures[id]
	collision.polygon = ItemDb.item_hitboxes[id]
	outline.polygon = ItemDb.item_hitboxes[id]
	print(id)
	print(collision.polygon)
	current_id = id

func set_top_left_pos(pos: Vector2) -> void:
	global_position = pos + sprite.get_rect().size / 2
