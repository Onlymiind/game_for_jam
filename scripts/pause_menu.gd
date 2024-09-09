extends Control

signal resume
signal quit_to_menu

func _on_resume_pressed():
	resume.emit()

func _on_quit_pressed():
	quit_to_menu.emit()
