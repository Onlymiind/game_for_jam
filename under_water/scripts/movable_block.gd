class_name MovableBlock extends RigidBody2D

@onready var sprites: Array = [$Sprite2D, $Sprite2D2, $Sprite2D3]

@export var sprite: int = -1

func _ready():
	if sprite < 0 or sprite >= sprites.size():
		sprite = randi_range(0, sprites.size() - 1)
	sprites[sprite].show()
