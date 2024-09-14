class_name Cursor extends Area2D

@onready var collision: CollisionShape2D = $collision

var hovered_items: Dictionary

func _ready() -> void:
	$animation.play("blink")

func disable() -> void:
	visible = false
	collision.disabled = true

func enable() -> void:
	visible = true
	collision.disabled = false

func get_bounding_box() -> Rect2:
	return Rect2(global_position - Vector2(32, 32), Vector2(64, 64))

func set_top_left_pos(pos: Vector2) -> void:
	global_position = pos + Vector2(32, 32)

func get_hovered_item() -> Item:
	if hovered_items.is_empty():
		return null
	return hovered_items.keys()[0]

func _on_area_entered(area: Area2D) -> void:
	if area is Item:
		hovered_items[area as Item] = true
		print(area)

func _on_area_exited(area: Area2D) -> void:
	if area is Item:
		hovered_items.erase(area as Item)
		print(area)
