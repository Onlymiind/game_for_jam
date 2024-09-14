class_name InventoryUI extends Control

@onready var item_list: ItemList = $MarginContainer/stash_ui/ScrollContainer/ItemList
@onready var display: TextureRect = $VBoxContainer/display
@onready var warning: Label = $MarginContainer/stash_ui/warning
@onready var cannot_close_warning: AnimationPlayer = $AnimationPlayer

@export var inventory_viewport: SubViewport
@export var inventory: Inventory

var current_items: PackedInt64Array

func _ready() -> void:
	display.texture = inventory_viewport.get_texture()
	inventory.item_removed.connect(_on_item_removed_from_inventory)

func set_items(items: PackedInt64Array) -> void:
	current_items = items
	item_list.clear()
	for item in items:
		item_list.add_item(ItemDb.item_names[item])

func clear_items() -> void:
	if current_items.is_empty():
		return
	current_items = []
	item_list.clear()

func _on_item_selected(idx: int) -> void:
	if inventory.try_spawn_item(current_items[idx]):
		current_items.remove_at(idx)
		item_list.remove_item(idx)

func set_top_text(display_warning: bool) -> void:
	if display_warning:
		warning.text = "Items here will be removed"
		warning.label_settings.font_color = Color.FIREBRICK
	else:
		warning.text = "Item stash:               "
		warning.label_settings.font_color = Color.WHITE

func close() -> void:
	cannot_close_warning.stop()
	cannot_close_warning.play("RESET")

func _on_item_removed_from_inventory(id: int) -> void:
	current_items.append(id)
	item_list.add_item(ItemDb.item_names[id])

func show_cannot_close_warning() -> void:
	cannot_close_warning.stop()
	cannot_close_warning.play("show_warning")
