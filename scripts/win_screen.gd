extends Control

@onready var score_label: Label = $PanelContainer/VBoxContainer/score

signal quit_to_menu
signal next_level

func set_score(score: int) -> void:
	score_label.text = "%d" % score

func _on_next_level_pressed() -> void:
	next_level.emit()

func _on_quit_to_menu_pressed() -> void:
	quit_to_menu.emit()
