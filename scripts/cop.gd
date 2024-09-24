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
@onready var point_select_timer: Timer = $point_select
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var player: Player
@export var home_region: NavigationRegion2D

const catch_distance: float = 1 * Constants.tile_size
const speed: float = 5 * Constants.tile_size
const sight_distance_tiles: float = 8 * Constants.tile_size
const squared_sight_distance: float = sight_distance_tiles * sight_distance_tiles

var is_chasing: bool = false
var is_on_screen: bool = true

signal player_caught

func _ready() -> void:
	sprite.texture = sprites[randi_range(0, sprites.size() - 1)]
	call_deferred("navigation_setup")

func navigation_setup() -> void:
	await  get_tree().physics_frame
	try_select_wander_point()

func _process(_delta: float) -> void:
	if player == null || (!is_chasing && !is_on_screen):
		return
	var player_sqared_distance = (player.global_position - global_position).length_squared()
	if player_sqared_distance > squared_sight_distance:
		return
	elif player_sqared_distance < catch_distance * catch_distance:
		player_caught.emit()
	sight.target_position = to_local(player.global_position)
	sight.force_raycast_update()
	if sight.is_colliding():
		return
	is_chasing = true
	point_select_timer.stop()
	agent.target_position = player.global_position

func _physics_process(_delta: float) -> void:
	if agent.is_navigation_finished() || (!is_chasing && !is_on_screen):
		return
	if !animation.is_playing():
		animation.play("walk")
	if !audio.playing:
		audio.play()
	var next_pos: Vector2 = agent.get_next_path_position()
	velocity = global_position.direction_to(next_pos) * speed
	move_and_slide()

func teleport_to_ladder(pos: Vector2) -> void:
	global_position = pos
	velocity = Vector2.ZERO
	collision_layer = Constants.cop_layer
	ladder_reset_timer.start()

func _on_ladder_reset() -> void:
	collision_layer = Constants.teleportable_layer | Constants.cop_layer

func try_select_wander_point() -> void:
	if agent.is_navigation_finished():
		is_chasing = false
		agent.target_position = NavigationServer2D.region_get_random_point(home_region.get_rid(), 1, false)


func _on_agent_navigation_finished() -> void:
	point_select_timer.start()
	animation.play("RESET")
	audio.stop()


func _on_point_select_timeout() -> void:
	try_select_wander_point()


func _on_screen_entered() -> void:
	is_on_screen = true

func _on_screen_exited() -> void:
	is_on_screen = false
