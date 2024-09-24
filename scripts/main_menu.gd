extends Control

const level_select_button: PackedScene = preload("res://level_select.tscn")

@onready var level_selec_container: GridContainer = $PanelContainer/VBoxContainer/GridContainer

func _ready() -> void:
	print(LevelDb.get_level_count())
	for i in range(LevelDb.get_level_count()):
		var button: Button = level_select_button.instantiate()
		button.set_level(i)
		button.level_selected.connect(_on_level_selected)
		level_selec_container.add_child(button)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_level_selected(id: int) -> void:
	LevelDb.load_level(id)
