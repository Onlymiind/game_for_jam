extends Node2D

var player_dead: bool = false
@onready var pause_menu: Control = $ui/pause_menu

func _input(event:InputEvent):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		pause_menu.visible = !pause_menu.visible

#func _on_player_died():
	#get_tree().paused = false
	#get_tree().change_scene_to_packed(Preload.lose_screen)

func _on_resume():
	get_tree().paused = false
	pause_menu.visible = false

#func _on_quit_to_menu():
	#get_tree().paused = false
	#get_tree().change_scene_to_packed(Preload.main_menu)
