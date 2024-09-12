class_name Inventory extends Node2D

@onready var held_item: Item
@onready var cursor: Cursor = $cursor
@onready var camera: Camera2D = $camera

var bounding_rect: Rect2
var intersection_count: int = 0

func _ready() -> void:
	bounding_rect = camera.get_viewport_rect()
	bounding_rect.position = -bounding_rect.size / 2
	for i in range(get_child_count()):
		var child = get_child(i)
		if child is Item:
			var item: Item = child as Item
			item.set_id(randi_range(0, ItemDb.get_item_count() - 1))
			item.area_entered.connect(_on_item_area_entered)
			item.area_exited.connect(_on_item_area_exited)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		move(Vector2(0, Constants.tile_size))
	elif event.is_action_pressed("up"):
		move(Vector2(0, -Constants.tile_size))
	elif event.is_action_pressed("left"):
		move(Vector2(-Constants.tile_size, 0))
	elif event.is_action_pressed("right"):
		move(Vector2(Constants.tile_size, 0))
	elif event.is_action_pressed("rotate_item") && held_item != null:
		rotate_held_item()
	elif event.is_action_pressed("accept"):
		if held_item == null:
			var hovered_item: Item = cursor.get_hovered_item()
			if hovered_item == null:
				return
			held_item = hovered_item
			cursor.disable()
			held_item.set_active()
		elif held_item != null && intersection_count == 0:
			held_item.set_inactive()
			cursor.global_position = held_item.global_position
			cursor.enable()
			held_item = null

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

func rotate_held_item() -> void:
	if held_item == null:
		return
	var item_rotation: float = (held_item.rotation + PI / 2)
	if abs(item_rotation - 2 * PI) < 1e-3:
		item_rotation = 0
	elif item_rotation > 2 * PI:
		item_rotation -= 2 * PI
	var item_bounding_box = held_item.get_bounding_box()
	if abs(item_rotation - PI / 2) < 1e-3 || abs(item_rotation - 3 * PI / 2) < 1e-3:
		var x: int = item_bounding_box.size.x
		item_bounding_box.size.x = item_bounding_box.size.y
		item_bounding_box.size.y = item_bounding_box.size.x
	if !bounding_rect.encloses(item_bounding_box):
		return
	held_item.rotation = item_rotation

func move_object(object: Area2D, translation: Vector2) -> void:
	var item_bounding_box: Rect2 = object.get_bounding_box()
	item_bounding_box.position += translation
	if not bounding_rect.encloses(item_bounding_box):
		return
	object.position += translation
