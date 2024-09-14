class_name ItemStash extends Area2D

@onready var tooltip: Label = $tooltip
@onready var object_sprite: Sprite2D = $object
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var item_names: PackedStringArray
@export var object_texture: Texture
@export var object_item_id: int = -1

var items: PackedInt64Array

func _ready() -> void:
	for name in item_names:
		items.append(ItemDb.item_names.find(name))
	$animation.play("blink")
	object_sprite.texture = object_texture
	update_status()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).add_item_stash(self)
		tooltip.show()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		(body as Player).remove_item_stash(self)
		tooltip.hide()

func take_item(idx: int) -> int:
	if idx < 0 || idx >= items.size():
		return -1
	var id: int = items[idx]
	items.remove_at(idx)
	return id

func update_status() -> void:
	if items.size() == 0:
		collision.disabled = true
		hide()
		return
	if object_texture == null || object_item_id < 0:
		return
	if items.count(object_item_id) > 0:
		object_sprite.show()
	else:
		object_sprite.hide()

func add_item(id: int) -> void:
	items.append(id)
