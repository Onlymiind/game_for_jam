extends Area2D

signal diver_entered
signal diver_exited

signal screen_entered
signal screen_exited

@onready var sprite: Sprite2D = $Sprite2D

func _on_body_entered(body: Node2D):
	if body is Diver:
		diver_entered.emit()
		(body as Diver).on_interaction_area_entered()

func _on_body_exited(body: Node2D):
	if body is Diver:
		diver_exited.emit()
		(body as Diver).on_interaction_area_exited()

func _on_screen_entered():
	screen_entered.emit()

func _on_screen_exited():
	screen_exited.emit()

func enable(pos: Vector2, rot: float, flip_h: bool):
	position = pos
	rotation = rot
	sprite.flip_h = flip_h
	show()
