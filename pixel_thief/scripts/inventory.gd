class_name Inventory extends Node2D

@onready var held_item: Item
@onready var cursor: Cursor = $cursor
@onready var camera: Camera2D = $camera
@onready var items: Node = $items

var item_scene: PackedScene = preload("res://item.tscn")

var bounding_rect: Rect2
var intersection_count: int = 0

signal item_removed(id: int)

func _ready() -> void:
	bounding_rect = camera.get_viewport_rect()
	bounding_rect.position = -bounding_rect.size / 2
	cursor.set_top_left_pos(bounding_rect.position)
	for i in range(get_child_count()):
		var child = get_child(i)
		if child is Item:
			var item: Item = child as Item
			item.set_id(randi_range(0, ItemDb.get_item_count() - 1))
			item.area_entered.connect(_on_item_area_entered)
			item.area_exited.connect(_on_item_area_exited)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		move(Vector2(0, Constants.item_tile_size))
	elif event.is_action_pressed("up"):
		move(Vector2(0, -Constants.item_tile_size))
	elif event.is_action_pressed("left"):
		move(Vector2(-Constants.item_tile_size, 0))
	elif event.is_action_pressed("right"):
		move(Vector2(Constants.item_tile_size, 0))
	elif event.is_action_pressed("rotate_item") && held_item != null:
		rotate_held_item()
	elif event.is_action_pressed("delete_item") && held_item != null:
		item_removed.emit(held_item.current_id)
		held_item.queue_free()
		force_put_item()
	elif event.is_action_pressed("accept"):
		if held_item == null:
			var hovered_item: Item = cursor.get_hovered_item()
			if hovered_item == null:
				return
			take_item(hovered_item)
		elif held_item != null:
			try_put_held_item()

func _on_item_area_entered(body: Node2D) -> void:
	if body == held_item:
		intersection_count += 1
		held_item.set_intersecting_color()

func _on_item_area_exited(body: Node2D) -> void:
	if body == held_item:
		intersection_count -= 1
	if intersection_count <= 0 && held_item != null:
		intersection_count = 0
		held_item.set_not_intersecting_color()

func move(translation: Vector2) -> void:
	if held_item != null:
		move_object(held_item, translation)
	else:
		move_object(cursor, translation)

func take_item(item: Item) -> void:
	held_item = item
	cursor.disable()
	held_item.set_active()

func try_spawn_item(id: int) -> bool:
	if held_item != null:
		return false
	var new_item: Item = item_scene.instantiate()
	items.add_child(new_item)
	new_item.set_id(id)
	new_item.set_top_left_pos(bounding_rect.position)
	new_item.area_entered.connect(_on_item_area_entered)
	new_item.area_exited.connect(_on_item_area_exited)
	take_item(new_item)
	return true

func try_put_held_item() -> void:
	if intersection_count > 0:
		return
	force_put_item()

func force_put_item() -> void:
	held_item.set_inactive()
	cursor.set_top_left_pos(held_item.get_bounding_box().position)
	cursor.enable()
	held_item = null
	intersection_count = 0

func rotate_held_item() -> void:
	if held_item == null:
		return
	var previous_rotation: float = held_item.rotation
	held_item.rotation += PI / 2
	if abs(held_item.rotation - 2 * PI) < 1e-3:
		held_item.rotation = 0
	elif held_item.rotation > 2 * PI:
		held_item.rotation -= 2 * PI
	var item_bounding_box: Rect2 = held_item.get_bounding_box()
	if !bounding_rect.encloses(item_bounding_box):
		held_item.rotation = previous_rotation

func move_object(object: Area2D, translation: Vector2) -> void:
	var item_bounding_box: Rect2 = object.get_bounding_box()
	item_bounding_box.position += translation
	if not bounding_rect.encloses(item_bounding_box):
		return
	object.position += translation

func force_update_cursor() -> void:
	cursor.disable()
	cursor.enable()

func can_close() -> bool:
	return held_item == null

func get_items() -> PackedInt64Array:
	var item_ids: PackedInt64Array
	for child in items.get_children():
		if !(child is Item):
			continue
		item_ids.append((child as Item).current_id)
	return item_ids
