extends HSlider

var master_bus_idx: int

func _ready():
	master_bus_idx = AudioServer.get_bus_index("Master")
	value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_idx))

func _on_drag_ended(_unchanged: bool):
	AudioServer.set_bus_volume_db(master_bus_idx, linear_to_db(value))
