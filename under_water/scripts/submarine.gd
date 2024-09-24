extends Character

@export var player: Character
@export var stationary: Area2D

@export var force: float = 40

func disable():
	super.disable()
	stationary.enable(position, rotation, sprite.flip_h)
	

func enable(_pos: Vector2):
	super.enable(position)
	stationary.hide()

func _input(event: InputEvent):
	if event.is_action_pressed("interact"):
		disable()
		player.enable(position)
		get_viewport().set_input_as_handled()

func _physics_process(delta:float):
	calculate_velocity(delta)
	
	if velocity != Vector2.ZERO:
		var dir = velocity
		if velocity.x < 0:
			sprite.flip_h = false
			collision.rotation = PI
			collision.scale.y = -1
			dir = -dir
		else:
			sprite.flip_h = true
			collision.rotation = 0
			collision.scale.y = 1
		look_at(position + dir)
	if move_and_slide():
		var count: int = get_slide_collision_count()
		for i in range(count):
			var coll: KinematicCollision2D = get_slide_collision(i)
			var collider = coll.get_collider()
			if collider is MovableBlock:
				(collider as MovableBlock).apply_central_impulse(-coll.get_normal() * force)
