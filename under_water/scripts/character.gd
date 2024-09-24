class_name Character extends CharacterBody2D

@export var speed: float = 400
@export var inertia: float = 1
@export var sprite: Sprite2D
@export var camera: Camera2D
@export var collision: Node2D

func enable(pos: Vector2):
	position = pos
	visible = true
	collision.disabled = false
	camera.enabled = true
	set_physics_process(true)
	set_process_input(true)

func disable():
	velocity = Vector2.ZERO
	visible = false
	collision.disabled = true
	camera.enabled = false
	set_physics_process(false)
	set_process_input(false)

func calculate_velocity(delta: float):
	var horisontal:float = Input.get_axis("left", "right")
	var vertical: float = Input.get_axis("up", "down")
	
	if horisontal != 0:
		velocity.x = velocity.x + horisontal * speed * delta
	elif velocity.x != 0:
		velocity.x *= inertia
	if vertical != 0:
		velocity.y = velocity.y + vertical * speed * delta
	elif velocity.y != 0:
		velocity.y *= inertia
	
	if velocity.length_squared() > speed * speed:
		velocity = velocity.normalized() * speed
