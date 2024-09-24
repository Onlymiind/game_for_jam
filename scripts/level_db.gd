extends Node

const _main_menu: PackedScene = preload("res://main_menu.tscn")
const _levels: Array[PackedScene] = [
	preload("res://levels/level_1.tscn"),
	preload("res://levels/level_2.tscn"),
]

const level_names: PackedStringArray = [
	"Level 1",
	"Level 2",
]

func next_level(current: int) -> void:
	if current < 0 || current >= _levels.size() - 1:
		get_tree().change_scene_to_packed(_main_menu)
	get_tree().change_scene_to_packed(_levels[current + 1])

func load_main_menu() -> void:
	get_tree().change_scene_to_packed(_main_menu)

func load_level(id: int) -> void:
	get_tree().change_scene_to_packed(_levels[id])

func get_level_count() -> int:
	return _levels.size()
