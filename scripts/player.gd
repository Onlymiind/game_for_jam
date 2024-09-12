class_name Player extends CharacterBody2D

@export var speed: float = 4
@export var sprint_speed: float = 8

var item_stashes: Dictionary

signal open_item_shash(stash: ItemStash)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && !item_stashes.is_empty():
		open_item_shash.emit(item_stashes.keys()[0])

func _physics_process(_delta: float) -> void:
	var dir: Vector2 = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	
	var current_speed: float = speed
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
	
	velocity = dir * current_speed * Constants.tile_size
	move_and_slide()

func add_item_stash(stash: ItemStash) -> void:
	item_stashes[stash] = true

func remove_item_stash(stash: ItemStash) -> void:
	item_stashes.erase(stash)

func teleport_to_ladder(pos: Vector2) -> void:
	global_position = pos
	velocity = Vector2.ZERO
