extends StaticBody2D

@export var wall: ExplosiveWall

@onready var active_sprite: Sprite2D = $active
@onready var used_sprite: Sprite2D = $used

func _on_body_entered(body: Node2D):
	if body is Diver:
		(body as Diver).on_interaction_area_entered()
		(body as Diver).add_interactable(self)

func _on_body_exited(body: Node2D):
	if body is Diver:
		(body as Diver).on_interaction_area_exited()
		(body as Diver).remove_interactable(self)

func interact():
	if wall != null:
		wall.explode()
		wall = null
	used_sprite.visible = true
	active_sprite.visible = false
	$Area2D/CollisionShape2D.disabled = true
