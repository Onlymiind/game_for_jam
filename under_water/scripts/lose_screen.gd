extends Control

func _on_quit_to_menu_pressed():
	get_tree().change_scene_to_packed(Preload.main_menu)
