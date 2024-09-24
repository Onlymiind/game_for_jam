extends CharacterBody2D

@onready var sprites: Array = [$Sprite2D, $Sprite2D2, $Sprite2D3]
@onready var timer: Timer = $Timer

@export var wander_radius: float = 200
@export var speed: float = 40

var home: Vector2
var sprite: int = 0

func _ready():
	sprite = randi_range(0, sprites.size() - 1)
	sprites[sprite].show()
	home = position
	select_wander_point()

func _physics_process(_delta: float):
	if move_and_slide():
		select_wander_point()

func select_wander_point():
	timer.stop()
	var target: Vector2 = random_target()
	var dir = target - position
	if dir.x < 0:
		if sprites[sprite].rotation < PI:
			sprites[sprite].rotation = sprites[sprite].rotation + PI
		dir = -dir
	elif sprites[sprite].rotation > PI:
		sprites[sprite].rotation = sprites[sprite].rotation - PI
	look_at(position + dir)
	
	var len = (target - position).length()
	velocity =((target - position) / len) * speed
	timer.start(len / speed)

func random_target():
	var direction = Vector2.RIGHT.rotated(randf_range(0.0, 2 * PI))
	var radius: float = wander_radius
	return home + direction * randf_range(radius * 0.3, radius)
