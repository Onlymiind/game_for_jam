extends Node2D

var player_dead: bool = false
@onready var pause_menu: Control = $ui/pause_menu
@onready var world_objects: Node = $pausable/world
@onready var inventory_ui: InventoryUI = $ui/inventory
@onready var inventory: Inventory = $pausable/SubViewport/inventory

@onready var stash: ItemStash = $pausable/world/item_stash

var is_in_inventory: bool = false
var opened_stash: ItemStash

func _input(event:InputEvent):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		pause_menu.visible = !pause_menu.visible
	elif event.is_action_pressed("inventory"):
		switch_inventory_status()
	elif is_in_inventory:
		$pausable/SubViewport.push_input(event)

#func _on_player_died():
	#get_tree().paused = false
	#get_tree().change_scene_to_packed(Preload.lose_screen)

func switch_inventory_status() -> void:
	if is_in_inventory:
		if !inventory.can_close():
			inventory_ui.show_cannot_close_warning()
			return
		world_objects.process_mode = Node.PROCESS_MODE_INHERIT
		inventory.hide()
		inventory_ui.hide()
		inventory_ui.close()
		inventory.process_mode = Node.PROCESS_MODE_DISABLED
		is_in_inventory = false
		if opened_stash != null:
			opened_stash.update_status()
			opened_stash = null
	else:
		open_inventory(null)

func open_inventory(item_stash: ItemStash) -> void:
	world_objects.process_mode = Node.PROCESS_MODE_DISABLED
	inventory.process_mode = Node.PROCESS_MODE_INHERIT
	inventory.show()
	inventory.force_update_cursor()
	inventory_ui.show()
	is_in_inventory = true
	if item_stash == null:
		inventory_ui.clear_items()
		inventory_ui.set_top_text(true)
	else:
		inventory_ui.set_top_text(false)
		inventory_ui.set_items(item_stash.items)

func _on_resume():
	get_tree().paused = false
	pause_menu.visible = false

func _on_open_item_stash(item_stash: ItemStash) -> void:
	opened_stash = item_stash
	open_inventory(item_stash)

#func _on_quit_to_menu():
	#get_tree().paused = false
	#get_tree().change_scene_to_packed(Preload.main_menu)
