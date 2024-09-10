extends Node2D

@onready var up: Area2D = $up
@onready var down: Area2D = $down

var just_teleported: bool = false


func _on_up_body_entered(body: Node2D) -> void:
	if body is Player:
		if just_teleported:
			just_teleported = false
			return
		just_teleported = true
		(body as Player).teleport_to_ladder(down.global_position)


func _on_down_body_entered(body: Node2D) -> void:
	if body is Player:
		if just_teleported:
			just_teleported = false
			return
		just_teleported = true
		(body as Player).teleport_to_ladder(up.global_position)
