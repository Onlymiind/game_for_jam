class_name Fish extends CharacterBody2D
@export var wander_radius: float = 100
@export var cooldown_time: float = 1
@export var speed: int = 50

@onready var sprites: Array = [$Sprite2D, $Sprite2D2]
@onready var timer: Timer = $Timer

var sprite: int = 0
var target_pos: Vector2 = Vector2.ZERO
var home: Vector2

func _ready():
	sprite = randi_range(0, sprites.size() - 1)
	sprites[sprite].show()
	home = position
	select_wander_point()

func _on_body_entered(body: Node2D):
	if body is Diver:
		(body as Diver).on_interaction_area_entered()
		(body as Diver).add_interactable(self)

func _on_body_exited(body: Node2D):
	if body is Diver:
		(body as Diver).on_interaction_area_exited()
		(body as Diver).remove_interactable(self)

func _physics_process(_delta: float):
	if move_and_slide():
		select_wander_point()

func select_wander_point():
	timer.stop()
	var target: Vector2 = random_target()
	var dir = target - position
	if dir.x < 0:
		sprites[sprite].flip_h = false
		dir = -dir
	else:
		sprites[sprite].flip_h = true
	look_at(position + dir)
	var len = (target - position).length()
	velocity =((target - position) / len) * speed
	timer.start(len / speed)

func interact():
	queue_free()

func random_target():
	var direction = Vector2.RIGHT.rotated(randf_range(0.0, 2 * PI))
	var radius: float = wander_radius
	return home + direction * randf_range(radius * 0.5, radius)
