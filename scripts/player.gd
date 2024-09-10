class_name Player extends CharacterBody2D

@export var speed: float = 4
@export var sprint_speed: float = 8

func _physics_process(delta: float) -> void:
	var dir: Vector2 = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	
	var current_speed: float = speed
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
	
	velocity = dir * current_speed * Constants.tile_size
	move_and_slide()

func set_item_stash(stash: ItemStash) -> void:
	pass

func remove_current_item_stash() -> void:
	pass

func teleport_to_ladder(pos: Vector2) -> void:
	global_position = pos
	velocity = Vector2.ZERO
