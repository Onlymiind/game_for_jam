extends Control

signal leave_level
signal stay_on_level

func _on_stay_pressed() -> void:
	stay_on_level.emit()


func _on_leave_pressed() -> void:
	leave_level.emit()
