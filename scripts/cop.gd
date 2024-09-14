class_name Cop extends CharacterBody2D

const sprites: Array[CompressedTexture2D] = [
	preload("res://assets/1--коп.png"),
	preload("res://assets/2-коп.png"),
	preload("res://assets/3-коп.png"),
	preload("res://assets/5-коп.png")
]

@onready var sprite: Sprite2D = $sprite
@onready var agent: NavigationAgent2D = $agent
@onready var ladder_reset_timer: Timer = $ladder_reset
@onready var sight: RayCast2D = $sight

@export var player: Player
@export var home_region: NavigationRegion2D

const speed: float = 4

var is_chasing: bool = false
var is_on_screen: bool = true

func _ready() -> void:
	sprite.texture = sprites[randi_range(0, sprites.size() - 1)]
	call_deferred("navigation_setup")

func navigation_setup() -> void:
	await  get_tree().physics_frame

func _process(_delta: float) -> void:
	if player == null:
		return
	sight.target_position = to_local(player.global_position)
	sight.force_raycast_update()
	if sight.is_colliding():
		if agent.is_navigation_finished():
			is_chasing = false
			agent.target_position = NavigationServer2D.region_get_random_point(home_region.get_rid(), 1, false)
		return
	is_chasing = true
	agent.target_position = player.global_position

func _physics_process(delta: float) -> void:
	if agent.is_navigation_finished():
		return
	var next_pos: Vector2 = agent.get_next_path_position()
	velocity = global_position.direction_to(next_pos) * speed * Constants.tile_size
	move_and_slide()

func teleport_to_ladder(pos: Vector2) -> void:
	global_position = pos
	velocity = Vector2.ZERO
	collision_layer = Constants.cop_layer
	ladder_reset_timer.start()

func _on_ladder_reset() -> void:
	collision_layer = Constants.teleportable_layer | Constants.cop_layer
