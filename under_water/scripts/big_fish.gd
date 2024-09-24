extends CharacterBody2D

@export var dash_speed: float = 200
@export var dash_distance: float = 400
@export var speed: float = 40
@export var wander_radius: float = 300
@export var damage: float = 10
@export var dash_cooldown_time: float = 6
@export var afterdash_cooldown: float = 1.5

const friction: float = 0.8

var player: Diver = null
var parent = null
var player_in_mouth: bool = false

@onready var sight: RayCast2D = $sight
@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
@onready var dash_cooldown: Timer = $dash_cooldown
@onready var mouth: Area2D = $mouth

@onready var home: Vector2 = position

var on_screen: bool = false

enum State {DASHING, WANDERING}
var state: State = State.WANDERING

func _ready():
	select_wander_point()

func _physics_process(delta: float):
	if player_in_mouth:
		damage_player()
	match(state):
		State.DASHING:
			dash(delta)
		State.WANDERING:
			wander()
	pass

func wander():
	if player && dash_cooldown.is_stopped():
		sight.target_position = sight.to_local(player.global_position)
		sight.force_raycast_update()
		if !sight.is_colliding():
			state = State.DASHING
			dash_cooldown.start(dash_cooldown_time)
			velocity = (player.global_position - global_position).normalized() * dash_speed
			turn_to(velocity)
			timer.start(dash_distance / dash_speed)
			return
	if move_and_slide():
		select_wander_point()

func dash(delta: float):
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		select_wander_point()

func on_player_enter(body: Node2D):
	if body is Diver:
		player = body as Diver

func on_player_leave(body: Node2D):
	if body is Diver:
		player = null

func on_player_enter_mouth(body: Node2D):
	if body is Diver:
		player_in_mouth = true

func on_player_left_mouth(body: Node2D):
	if body is Diver:
		player_in_mouth = false

func select_wander_point():
	if !on_screen:
		process_mode = Node.PROCESS_MODE_DISABLED
	timer.stop()
	if state != State.WANDERING:
		state = State.WANDERING
		home = position
		velocity = velocity.normalized() * 0.5 * speed
		timer.start(afterdash_cooldown)
		return
	var target: Vector2 = random_target()
	turn_to(target - position)
	var len = (target - position).length()
	velocity =((target - position) / len) * speed
	timer.start(len / speed)

func turn_to(dir: Vector2):
	if dir.x < 0:
		sprite.flip_h = false
		mouth.position = -abs(mouth.position)
		dir = -dir
	else:
		sprite.flip_h = true
		mouth.position = abs(mouth.position)
	look_at(global_position + dir)

func random_target():
	var direction = Vector2.RIGHT.rotated(randf_range(0.0, 2 * PI))
	var radius: float = wander_radius
	return home + direction * randf_range(radius * 0.5, radius)

func damage_player():
	player.take_damage(damage, (global_position - player.global_position).normalized())

func _on_screen_entered():
	process_mode = Node.PROCESS_MODE_INHERIT
	on_screen = true

func _on_screen_exited():
	on_screen = false
