extends Node2D

var player_dead: bool = false
@onready var pause_menu: Control = $ui/pause_menu
@onready var world_objects: Node2D = $pausable/world
@onready var inventory_ui: InventoryUI = $ui/inventory
@onready var inventory: Inventory = $pausable/SubViewport/inventory
@onready var police_timer: Timer = $pausable/police_timer
@onready var hud: HUD = $ui/hud
@onready var pausable: Node = $pausable
@onready var level_exit_ui: Control = $ui/level_exit_ui
@onready var level_exit_cooldown_timer: Timer = $level_exit_cooldown
@onready var cops_spawn: Node2D = $pausable/world/cops_spawn
@onready var navigation_regions: Node = $navigation/regions
@onready var player: Player = $pausable/world/player
@onready var lose_screen: Control = $ui/lose_screen
@onready var win_screen: Control = $ui/win_screen

@export var level_id: int = -1
@export var cops_number: int = 3

var is_in_inventory: bool = false
var opened_stash: ItemStash

var can_pause: bool = true

const cop_scene: PackedScene = preload("res://cop.tscn")

func _ready() -> void:
	hud.set_level_status(false)
	hud.set_time_to_police(police_timer.time_left)
	$AudioStreamPlayer.play()

func _input(event:InputEvent):
	if event.is_action_pressed("pause") && can_pause:
		if pausable.process_mode == Node.PROCESS_MODE_DISABLED:
			set_paused.call_deferred(pausable, false)
		else:
			set_paused.call_deferred(pausable, true)
		pause_menu.visible = !pause_menu.visible
	elif event.is_action_pressed("inventory") && pausable.process_mode != Node.PROCESS_MODE_DISABLED:
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
		set_paused.call_deferred(world_objects, false)
		inventory.hide()
		inventory_ui.hide()
		inventory_ui.close()
		set_paused.call_deferred(inventory, true)
		is_in_inventory = false
		if opened_stash != null:
			opened_stash.update_status()
			opened_stash = null
	else:
		open_inventory(null)

func open_inventory(item_stash: ItemStash) -> void:
	set_paused.call_deferred(world_objects, true)
	set_paused.call_deferred(inventory, false)
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
	set_paused.call_deferred(pausable, false)
	pause_menu.visible = false

func _on_open_item_stash(item_stash: ItemStash) -> void:
	opened_stash = item_stash
	open_inventory(item_stash)

func _process(_delta: float) -> void:
	if police_timer.is_stopped():
		return
	hud.set_time_to_police(police_timer.time_left)

func _on_police_timer_timeout() -> void:
	hud.set_level_status(true)
	for i in range(cops_number):
		var cop: Cop = cop_scene.instantiate()
		cop.home_region = navigation_regions.get_child(randi_range(0, navigation_regions.get_child_count() - 1))
		cop.player = player
		cop.player_caught.connect(_on_player_caught)
		cops_spawn.add_child(cop)

func _on_quit_to_menu():
	LevelDb.load_main_menu()


func _on_level_exited() -> void:
	if !level_exit_cooldown_timer.is_stopped():
		return
	level_exit_ui.show()
	set_paused.call_deferred(pausable, true)
	can_pause = false


func _on_stay_on_level() -> void:
	can_pause = true
	level_exit_ui.hide()
	set_paused.call_deferred(pausable, false)
	level_exit_cooldown_timer.start()


func _on_leave_level() -> void:
	var score: int = 0
	var items: PackedInt64Array = inventory.get_items()
	for id in items:
		score += ItemDb.item_scores[id]
	level_exit_ui.hide()
	win_screen.set_score(score)
	win_screen.show()

func _on_player_caught() -> void:
	set_paused.call_deferred(pausable, true)
	lose_screen.show()

func _on_restart() -> void:
	get_tree().reload_current_scene()


func _on_next_level() -> void:
	LevelDb.next_level(level_id)

func set_paused(node: Node, val: bool) -> void:
	if val:
		node.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		node.process_mode = Node.PROCESS_MODE_INHERIT
