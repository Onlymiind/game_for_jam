extends VBoxContainer

func _on_play_pressed():
	get_tree().change_scene_to_packed(Preload.game)

func _on_quit_pressed():
	get_tree().quit()
