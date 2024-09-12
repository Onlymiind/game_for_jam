extends Node2D

var player_dead: bool = false
@onready var pause_menu: Control = $ui/pause_menu
@onready var world_objects: Node = $pausable/world
@onready var inventory_display: Control = $ui/inventory
@onready var inventory: Node2D = $pausable/SubViewport/inventory

var is_in_inventory: bool = false

func _input(event:InputEvent):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		pause_menu.visible = !pause_menu.visible
	elif event.is_action_pressed("inventory"):
		if is_in_inventory:
			world_objects.process_mode = Node.PROCESS_MODE_INHERIT
			inventory.hide()
			inventory_display.hide()
			inventory.process_mode = Node.PROCESS_MODE_DISABLED
			is_in_inventory = false
		else:
			world_objects.process_mode = Node.PROCESS_MODE_DISABLED
			inventory.show()
			inventory_display.show()
			inventory.process_mode = Node.PROCESS_MODE_INHERIT
			is_in_inventory = true
	elif is_in_inventory:
		$pausable/SubViewport.push_input(event)

#func _on_player_died():
	#get_tree().paused = false
	#get_tree().change_scene_to_packed(Preload.lose_screen)

func _on_resume():
	get_tree().paused = false
	pause_menu.visible = false

#func _on_quit_to_menu():
	#get_tree().paused = false
	#get_tree().change_scene_to_packed(Preload.main_menu)
