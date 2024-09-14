extends Node2D

@onready var up: Area2D = $up
@onready var down: Area2D = $down
@onready var navigation_link: NavigationLink2D = $NavigationLink2D

func _ready() -> void:
	navigation_link.start_position = up.global_position
	navigation_link.end_position = down.global_position

func _on_up_body_entered(body: Node2D) -> void:
	body.teleport_to_ladder(down.global_position)

func _on_down_body_entered(body: Node2D) -> void:
	body.teleport_to_ladder(up.global_position)
