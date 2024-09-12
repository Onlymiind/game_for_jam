class_name ItemStash extends Area2D

@onready var tooltip: Label = $tooltip

@export var items: PackedInt64Array

func _ready() -> void:
	$animation.play("blink")

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

func add_item(id: int) -> void:
	items.append(id)
