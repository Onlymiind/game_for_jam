extends Area2D

signal level_exited

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		level_exited.emit()
