extends Control

signal restart
signal quit_to_menu

func _on_restart_pressed() -> void:
	restart.emit()


func _on_quit_to_menu_pressed() -> void:
	quit_to_menu.emit()
