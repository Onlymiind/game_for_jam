extends Button

var level_id: int

signal level_selected(id: int)

func set_level(id: int) -> void:
	level_id = id
	text = LevelDb.level_names[id]


func _on_pressed() -> void:
	level_selected.emit(level_id)
