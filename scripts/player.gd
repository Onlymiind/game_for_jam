class_name Player extends CharacterBody2D

@export var speed: float = 4
@export var sprint_speed: float = 8
@export var stamina: float = max_stamina
@export var running_time: float = 6
@export var regen_time: float = 8

@onready var ladder_reset_timer: Timer = $ladder_reset

const max_stamina: float = 100
var item_stashes: Dictionary

signal open_item_shash(stash: ItemStash)
signal stamina_changed(percentage: float)
signal stamina_ran_out
signal stamina_replenished

var can_run: bool = true
var stamina_decrease: float
var stamina_increase: float

var can_teleport: bool = true

func _ready() -> void:
	stamina_decrease = max_stamina / running_time
	stamina_increase = max_stamina / regen_time
	stamina_changed.emit(stamina)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && !item_stashes.is_empty():
		open_item_shash.emit(item_stashes.keys()[0])

func _physics_process(delta: float) -> void:
	var dir: Vector2 = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	
	var current_speed: float = speed
	var stamina_delta: float = 0
	if Input.is_action_pressed("sprint") && can_run:
		current_speed = sprint_speed
		stamina_delta = -stamina_decrease * delta
	elif stamina < max_stamina:
		stamina_delta = stamina_increase * delta
	
	velocity = dir * current_speed * Constants.tile_size
	if velocity != Vector2.ZERO || stamina_delta > 0:
		stamina += stamina_delta
		if stamina <= 0:
			stamina = 0
			stamina_ran_out.emit()
			can_run = false
		elif stamina >= max_stamina:
			stamina = max_stamina
			stamina_replenished.emit()
			can_run = true
		stamina_changed.emit(stamina/max_stamina)
	move_and_slide()

func add_item_stash(stash: ItemStash) -> void:
	item_stashes[stash] = true

func remove_item_stash(stash: ItemStash) -> void:
	item_stashes.erase(stash)

func teleport_to_ladder(pos: Vector2) -> void:
	if !can_teleport:
		return
	global_position = pos
	velocity = Vector2.ZERO
	can_teleport = false
	ladder_reset_timer.start()

func _on_ladder_reset() -> void:
	can_teleport = true
